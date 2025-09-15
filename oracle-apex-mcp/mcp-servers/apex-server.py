#!/usr/bin/env python3
"""
Servidor MCP personalizado para Oracle APEX com python-oracledb.
"""
import os
import sys
from typing import Any, Dict, List, Optional
import oracledb
from mcp.server.fastmcp import FastMCP

mcp = FastMCP("oracle-apex-assistant")

# --- Configuração da Conexão ---
DB_USER = os.getenv("DB_USER", "apex_mcp_user")
DB_PASSWORD = os.getenv("DB_PASSWORD")
DB_DSN = os.getenv("DB_DSN", "//localhost:1521/FREEPDB1")

try:
    oracledb.init_oracle_client()
except Exception:
    print("Aviso: Oracle Instant Client não encontrado. O modo 'Thick' pode falhar.")

def get_db_connection():
    if not DB_PASSWORD:
        raise ValueError("A variável de ambiente DB_PASSWORD não está definida.")
    return oracledb.connect(user=DB_USER, password=DB_PASSWORD, dsn=DB_DSN)

def serialize_row(description, row):
    """Converte uma linha da base de dados num dicionário serializável."""
    d = dict(zip([desc[0].lower() for desc in description], row))
    for key, value in d.items():
        if hasattr(value, 'isoformat'):
            d[key] = value.isoformat()
    return d

# --- Ferramentas MCP ---

@mcp.tool()
async def list_apex_applications(workspace_name: Optional[str] = None) -> Dict[str, Any]:
    """Lista todas as aplicações APEX num workspace específico."""
    try:
        with get_db_connection() as conn:
            with conn.cursor() as cursor:
                sql = "SELECT * FROM apex_applications"
                params = {}
                if workspace_name:
                    sql += " WHERE workspace = :ws"
                    params['ws'] = workspace_name
                cursor.execute(sql, params)
                apps = [serialize_row(cursor.description, row) for row in cursor.fetchall()]
        return {"status": "success", "count": len(apps), "applications": apps}
    except Exception as e:
        return {"status": "error", "message": str(e)}

@mcp.tool()
async def get_apex_app_details(application_id: int) -> Dict[str, Any]:
    """Obtém detalhes completos de uma aplicação APEX específica."""
    try:
        with get_db_connection() as conn:
            with conn.cursor() as cursor:
                # App info
                cursor.execute("SELECT * FROM apex_applications WHERE application_id = :id", {'id': application_id})
                app_info = serialize_row(cursor.description, cursor.fetchone() or [])
                # Pages
                cursor.execute("SELECT * FROM apex_application_pages WHERE application_id = :id ORDER BY page_id", {'id': application_id})
                pages = [serialize_row(cursor.description, row) for row in cursor.fetchall()]
                # Items
                cursor.execute("SELECT * FROM apex_application_page_items WHERE application_id = :id ORDER BY page_id", {'id': application_id})
                items = [serialize_row(cursor.description, row) for row in cursor.fetchall()]
        
        return {
            "status": "success", "application": app_info, "pages": pages, "items": items,
            "summary": {"total_pages": len(pages), "total_items": len(items)}
        }
    except Exception as e:
        return {"status": "error", "message": str(e)}

@mcp.tool()
async def generate_apex_page_sql(page_type: str, page_name: str, table_name: str, application_id: int) -> Dict[str, Any]:
    """Gera SQL para criar uma nova página APEX."""
    sql_template = f"""
-- SQL para gerar página '{page_name}' do tipo '{page_type}'
-- Esta é uma representação. A criação real deve ser feita com APIs APEX.
SELECT 'Criar página: {page_name}' as ACAO, '{table_name}' as TABELA_BASE FROM DUAL;
-- Para uma implementação real, usar APEX_APPLICATION_INSTALL API.
"""
    return {"status": "success", "sql_code": sql_template}

@mcp.tool()
async def export_apex_application(application_id: int) -> Dict[str, Any]:
    """Exporta uma aplicação APEX completa."""
    try:
        with get_db_connection() as conn:
            with conn.cursor() as cursor:
                export_sql = """
                DECLARE
                    l_files apex_t_export_files;
                BEGIN
                    l_files := apex_export.get_application(p_application_id => :app_id);
                    :export_content := l_files(1).contents;
                    :file_name := l_files(1).name;
                END;
                """
                export_content = cursor.var(oracledb.DB_TYPE_CLOB)
                file_name_var = cursor.var(str, 255)
                cursor.execute(export_sql, app_id=application_id, export_content=export_content, file_name=file_name_var)
                
                file_name = file_name_var.getvalue()
                content = export_content.getvalue().read()
                
                export_path = f"/tmp/{file_name}"
                with open(export_path, "w", encoding='utf-8') as f:
                    f.write(content)

        return {"status": "success", "file_path": export_path, "file_name": file_name}
    except Exception as e:
        return {"status": "error", "message": f"Erro na exportação (requer privilégios APEX): {e}"}

@mcp.tool()
async def analyze_apex_performance(application_id: int, days_back: int = 7) -> Dict[str, Any]:
    """Analisa a performance de uma aplicação APEX."""
    try:
        with get_db_connection() as conn:
            with conn.cursor() as cursor:
                sql = """
                SELECT page_id, COUNT(*) as page_views, AVG(elapsed_time) as avg_response_time
                FROM apex_workspace_activity_log
                WHERE application_id = :app_id AND view_date >= SYSDATE - :days
                GROUP BY page_id ORDER BY page_views DESC
                """
                cursor.execute(sql, app_id=application_id, days=days_back)
                perf_data = [serialize_row(cursor.description, row) for row in cursor.fetchall()]
        
        slow_pages = [p for p in perf_data if p.get('avg_response_time', 0) > 2.0]
        return {"status": "success", "performance_data": perf_data, "insights": {"slow_pages": slow_pages}}
    except Exception as e:
        return {"status": "error", "message": str(e)}

if __name__ == "__main__":
    if not DB_PASSWORD:
        sys.exit("Erro: A variável de ambiente DB_PASSWORD é obrigatória.")
    mcp.run()
