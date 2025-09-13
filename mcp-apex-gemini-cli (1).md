# **Guia Completo: Configurar MCP para Oracle APEX com Gemini CLI**

**Guia detalhado para implementar Model Context Protocol (MCP) que apoie o desenvolvimento Oracle APEX através do Gemini CLI, permitindo interações em linguagem natural com bases de dados, aplicações APEX e APIs.**

---

## **Índice**
1. [Introdução e Conceitos Básicos](#introdução-e-conceitos-básicos)
2. [Pré-requisitos e Preparação do Ambiente](#pré-requisitos-e-preparação-do-ambiente)
3. [Configuração do Oracle SQLcl MCP Server](#configuração-do-oracle-sqlcl-mcp-server)
4. [Criação de Servidor MCP Personalizado para APEX](#criação-de-servidor-mcp-personalizado-para-apex)
5. [Configuração do Gemini CLI](#configuração-do-gemini-cli)
6. [Exemplos Práticos de Uso](#exemplos-práticos-de-uso)
7. [Resolução de Problemas](#resolução-de-problemas)
8. [Casos de Uso Avançados](#casos-de-uso-avançados)

---

## **Introdução e Conceitos Básicos**

### **O que é MCP (Model Context Protocol)?**
Model Context Protocol é um protocolo padronizado que permite aos modelos de IA aceder a ferramentas e recursos externos de forma segura e controlada. No contexto Oracle APEX, permite que o Gemini CLI:

- Execute consultas SQL diretamente na base de dados
- Aceda a metadados de aplicações APEX
- Gere componentes APEX automaticamente
- Gerencie recursos através de APIs REST
- Mantenha auditoria completa de todas as operações

### **Arquitectura da Solução**
```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   Gemini CLI    │◄──►│  MCP Servers     │◄──►│ Oracle Database │
│                 │    │                  │    │    + APEX       │
│ - Chat interface│    │ - SQLcl MCP      │    │                 │
│ - Tool calls    │    │ - APEX Custom    │    │ - Aplicações    │
│ - Permissions   │    │ - REST APIs      │    │ - Metadados     │
└─────────────────┘    └──────────────────┘    └─────────────────┘
```

---

## **Pré-requisitos e Preparação do Ambiente**

### **Software Necessário**
1. **Oracle Database 23ai ou superior** (ou Oracle Database 19c/21c)
2. **Oracle SQLcl 25.2 ou superior**
3. **Java Runtime Environment (JRE) 17 ou superior**
4. **Gemini CLI** (versão mais recente)
5. **Python 3.8+** (para servidor MCP personalizado)
6. **Node.js 18+** (opcional, para servidores MCP em JavaScript)

### **Verificar Pré-requisitos**

```bash
# Verificar Java
java -version

# Verificar Python
python --version

# Verificar Node.js (opcional)
node --version

# Verificar Gemini CLI
gemini --version
```

### **Estrutura de Directórios Recomendada**
```
oracle-apex-mcp/
├── sqlcl/                    # Instalação SQLcl
├── mcp-servers/              # Servidores MCP personalizados
│   ├── apex-server.py        # Servidor APEX personalizado
│   └── requirements.txt      # Dependências Python
├── config/                   # Ficheiros de configuração
│   ├── connections.json      # Conexões de BD
│   └── settings.json         # Configurações Gemini CLI
└── scripts/                  # Scripts utilitários
    ├── setup.sh              # Script de instalação
    └── backup.sh             # Script de backup
```

---

## **Configuração do Oracle SQLcl MCP Server**

### **Passo 1: Instalar Oracle SQLcl 25.2**

```bash
# Baixar SQLcl do site oficial Oracle
wget https://download.oracle.com/otn_software/java/sqldeveloper/sqlcl-25.2.0.xxx.zip

# Extrair
unzip sqlcl-25.2.0.xxx.zip -d /opt/oracle/

# Criar link simbólico (opcional)
sudo ln -sf /opt/oracle/sqlcl/bin/sql /usr/local/bin/sql

# Verificar instalação
sql -version
```

### **Passo 2: Configurar Conexões Oracle APEX**

#### **Criar Utilizador Dedicado para MCP**
```sql
-- Conectar como SYSDBA
CREATE USER apex_mcp_user IDENTIFIED BY "Password123!";

-- Conceder privilégios básicos
GRANT CONNECT, RESOURCE TO apex_mcp_user;

-- Conceder privilégios APEX (ajustar conforme necessário)
GRANT APEX_ADMINISTRATOR_ROLE TO apex_mcp_user;
GRANT SELECT ANY TABLE TO apex_mcp_user;
GRANT EXECUTE ON DBMS_METADATA TO apex_mcp_user;

-- Para desenvolvimento (conceder com cautela)
GRANT CREATE ANY TABLE TO apex_mcp_user;
GRANT ALTER ANY TABLE TO apex_mcp_user;
```

#### **Configurar Conexões SQLcl**
```bash
# Iniciar SQLcl
sql /nolog

# Conectar e salvar conexão para MCP
SQL> connect apex_mcp_user/Password123!@//localhost:1521/XEPDB1
SQL> conn -save mcp_apex -savepwd apex_mcp_user/Password123!@//localhost:1521/XEPDB1

# Verificar conexão salva
SQL> conn -list
```

### **Passo 3: Testar SQLcl MCP Server**

```bash
# Testar servidor MCP em modo standalone
sql -mcp

# Em outro terminal, testar conectividade
curl -X POST http://localhost:3000/mcp/tools
```

---

## **Criação de Servidor MCP Personalizado para APEX**

### **Servidor Python para APIs APEX**

#### **Ficheiro: mcp-servers/apex-server.py**
```python
#!/usr/bin/env python3
"""
Servidor MCP personalizado para Oracle APEX
Fornece ferramentas para desenvolvimento e gestão de aplicações APEX
"""

import asyncio
import json
import os
import sys
from typing import Any, Dict, List, Optional
import httpx
import cx_Oracle

# Adicionar biblioteca MCP
sys.path.append(os.path.join(os.path.dirname(__file__), '..'))

from mcp.server.fastmcp import FastMCP
from mcp.types import Tool, TextContent

# Configuração
mcp = FastMCP("oracle-apex-assistant")

# Variáveis de ambiente
APEX_BASE_URL = os.getenv("APEX_BASE_URL", "https://apex.oracle.com")
APEX_WORKSPACE = os.getenv("APEX_WORKSPACE", "")
APEX_USERNAME = os.getenv("APEX_USERNAME", "")
APEX_PASSWORD = os.getenv("APEX_PASSWORD", "")
DB_CONNECTION_STRING = os.getenv("DB_CONNECTION_STRING", "")

# Cache para metadados
_metadata_cache = {}

@mcp.tool()
async def list_apex_applications(workspace_name: Optional[str] = None) -> Dict[str, Any]:
    """
    Lista todas as aplicações APEX no workspace especificado
    
    Args:
        workspace_name: Nome do workspace (opcional, usa o padrão se não especificado)
    
    Returns:
        Lista de aplicações com metadados básicos
    """
    workspace = workspace_name or APEX_WORKSPACE
    
    try:
        # Usar cx_Oracle para conectar diretamente à base de dados
        connection = cx_Oracle.connect(DB_CONNECTION_STRING)
        cursor = connection.cursor()
        
        query = """
        SELECT 
            application_id,
            application_name,
            application_group,
            build_status,
            availability_status,
            authorization_scheme,
            created_by,
            created_on,
            last_updated_by,
            last_updated_on,
            version
        FROM apex_applications 
        WHERE workspace = :workspace
        ORDER BY application_name
        """
        
        cursor.execute(query, {'workspace': workspace})
        columns = [desc[0] for desc in cursor.description]
        
        applications = []
        for row in cursor.fetchall():
            app_dict = dict(zip(columns, row))
            # Converter dates para strings
            for key, value in app_dict.items():
                if hasattr(value, 'isoformat'):
                    app_dict[key] = value.isoformat()
            applications.append(app_dict)
        
        cursor.close()
        connection.close()
        
        return {
            "status": "success",
            "workspace": workspace,
            "count": len(applications),
            "applications": applications
        }
        
    except Exception as e:
        return {
            "status": "error",
            "message": f"Erro ao listar aplicações: {str(e)}"
        }

@mcp.tool()
async def get_apex_app_details(application_id: int) -> Dict[str, Any]:
    """
    Obtém detalhes completos de uma aplicação APEX específica
    
    Args:
        application_id: ID da aplicação APEX
    
    Returns:
        Detalhes completos da aplicação incluindo páginas, itens e processos
    """
    try:
        connection = cx_Oracle.connect(DB_CONNECTION_STRING)
        cursor = connection.cursor()
        
        # Informações da aplicação
        app_query = """
        SELECT * FROM apex_applications 
        WHERE application_id = :app_id
        """
        cursor.execute(app_query, {'app_id': application_id})
        app_info = dict(zip([desc[0] for desc in cursor.description], cursor.fetchone() or []))
        
        # Páginas da aplicação
        pages_query = """
        SELECT 
            page_id, 
            page_name, 
            page_title, 
            page_mode,
            page_template,
            authentication,
            authorization_scheme,
            last_updated_on
        FROM apex_application_pages 
        WHERE application_id = :app_id
        ORDER BY page_id
        """
        cursor.execute(pages_query, {'app_id': application_id})
        pages = []
        for row in cursor.fetchall():
            page_dict = dict(zip([desc[0] for desc in cursor.description], row))
            if hasattr(page_dict.get('LAST_UPDATED_ON'), 'isoformat'):
                page_dict['LAST_UPDATED_ON'] = page_dict['LAST_UPDATED_ON'].isoformat()
            pages.append(page_dict)
        
        # Itens da aplicação
        items_query = """
        SELECT 
            page_id,
            item_name,
            display_as,
            label,
            placeholder,
            source_type,
            data_type,
            is_required
        FROM apex_application_page_items 
        WHERE application_id = :app_id
        ORDER BY page_id, display_sequence
        """
        cursor.execute(items_query, {'app_id': application_id})
        items = [dict(zip([desc[0] for desc in cursor.description], row)) for row in cursor.fetchall()]
        
        cursor.close()
        connection.close()
        
        return {
            "status": "success",
            "application": app_info,
            "pages": pages,
            "items": items,
            "summary": {
                "total_pages": len(pages),
                "total_items": len(items),
                "last_modified": max([p.get('LAST_UPDATED_ON', '') for p in pages] or [''])
            }
        }
        
    except Exception as e:
        return {
            "status": "error",
            "message": f"Erro ao obter detalhes da aplicação {application_id}: {str(e)}"
        }

@mcp.tool()
async def generate_apex_page_sql(
    page_type: str,
    page_name: str,
    table_name: str,
    application_id: int,
    page_id: Optional[int] = None
) -> Dict[str, Any]:
    """
    Gera SQL para criar uma nova página APEX
    
    Args:
        page_type: Tipo de página (report, form, chart, dashboard)
        page_name: Nome da página
        table_name: Tabela base para a página
        application_id: ID da aplicação APEX
        page_id: ID da página (opcional, será calculado automaticamente)
    
    Returns:
        SQL gerado para criação da página
    """
    try:
        if not page_id:
            # Calcular próximo page_id disponível
            connection = cx_Oracle.connect(DB_CONNECTION_STRING)
            cursor = connection.cursor()
            cursor.execute(
                "SELECT NVL(MAX(page_id), 0) + 1 FROM apex_application_pages WHERE application_id = :app_id",
                {'app_id': application_id}
            )
            page_id = cursor.fetchone()[0]
            cursor.close()
            connection.close()
        
        templates = {
            "report": f"""
-- Página de Relatório Interactivo: {page_name}
DECLARE
    l_page_id NUMBER := {page_id};
BEGIN
    -- Criar página
    apex_application_install.create_page(
        p_id => l_page_id,
        p_application_id => {application_id},
        p_name => '{page_name}',
        p_title => '{page_name}',
        p_page_template => 'Standard',
        p_page_mode => 'NORMAL'
    );
    
    -- Adicionar região de relatório interactivo
    apex_application_install.create_page_region(
        p_page_id => l_page_id,
        p_application_id => {application_id},
        p_display_as => 'NATIVE_IR',
        p_title => 'Relatório {page_name}',
        p_source_type => 'SQL_QUERY',
        p_source => 'SELECT * FROM {table_name}',
        p_template => 'Standard'
    );
END;
/""",
            
            "form": f"""
-- Página de Formulário: {page_name}
DECLARE
    l_page_id NUMBER := {page_id};
BEGIN
    -- Criar página
    apex_application_install.create_page(
        p_id => l_page_id,
        p_application_id => {application_id},
        p_name => '{page_name}',
        p_title => '{page_name}',
        p_page_template => 'Standard',
        p_page_mode => 'MODAL_DIALOG'
    );
    
    -- Adicionar região de formulário
    apex_application_install.create_page_region(
        p_page_id => l_page_id,
        p_application_id => {application_id},
        p_display_as => 'NATIVE_FORM',
        p_title => 'Editar {page_name}',
        p_source_type => 'TABLE',
        p_source => '{table_name}',
        p_template => 'Standard'
    );
END;
/""",
            
            "chart": f"""
-- Página de Gráfico: {page_name}
DECLARE
    l_page_id NUMBER := {page_id};
BEGIN
    -- Criar página
    apex_application_install.create_page(
        p_id => l_page_id,
        p_application_id => {application_id},
        p_name => '{page_name}',
        p_title => '{page_name}',
        p_page_template => 'Standard',
        p_page_mode => 'NORMAL'
    );
    
    -- Adicionar região de gráfico
    apex_application_install.create_page_region(
        p_page_id => l_page_id,
        p_application_id => {application_id},
        p_display_as => 'NATIVE_JET_CHART',
        p_title => 'Gráfico {page_name}',
        p_source_type => 'SQL_QUERY',
        p_source => 'SELECT categoria, COUNT(*) as valor FROM {table_name} GROUP BY categoria',
        p_template => 'Standard'
    );
END;
/"""
        }
        
        sql_code = templates.get(page_type.lower(), templates["report"])
        
        return {
            "status": "success",
            "page_type": page_type,
            "page_id": page_id,
            "sql_code": sql_code,
            "instructions": f"Execute este SQL no SQLcl ou SQL Workshop para criar a página {page_name}"
        }
        
    except Exception as e:
        return {
            "status": "error",
            "message": f"Erro ao gerar SQL da página: {str(e)}"
        }

@mcp.tool()
async def export_apex_application(
    application_id: int,
    export_format: str = "SQL_SCRIPT",
    include_data: bool = False
) -> Dict[str, Any]:
    """
    Exporta uma aplicação APEX completa
    
    Args:
        application_id: ID da aplicação para exportar
        export_format: Formato da exportação (SQL_SCRIPT, SQL_ZIP)
        include_data: Incluir dados das tabelas
    
    Returns:
        Informações sobre o ficheiro exportado
    """
    try:
        connection = cx_Oracle.connect(DB_CONNECTION_STRING)
        cursor = connection.cursor()
        
        # Usar API APEX para exportar
        export_sql = f"""
        DECLARE
            l_export apex_t_export_file;
            l_files apex_t_export_files;
        BEGIN
            l_files := apex_export.get_application(
                p_application_id => {application_id},
                p_with_date => true,
                p_with_comments => true,
                p_format => 'SQL'
            );
            
            :export_content := l_files(1).contents;
            :file_name := l_files(1).name;
        END;
        """
        
        export_content = cursor.var(cx_Oracle.CLOB)
        file_name = cursor.var(cx_Oracle.STRING)
        
        cursor.execute(export_sql, {
            'export_content': export_content,
            'file_name': file_name
        })
        
        # Salvar ficheiro localmente
        export_dir = "/tmp/apex_exports"
        os.makedirs(export_dir, exist_ok=True)
        
        file_path = os.path.join(export_dir, file_name.getvalue())
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(export_content.getvalue())
        
        cursor.close()
        connection.close()
        
        return {
            "status": "success",
            "application_id": application_id,
            "file_name": file_name.getvalue(),
            "file_path": file_path,
            "file_size": os.path.getsize(file_path),
            "format": export_format,
            "includes_data": include_data
        }
        
    except Exception as e:
        return {
            "status": "error",
            "message": f"Erro ao exportar aplicação {application_id}: {str(e)}"
        }

@mcp.tool()
async def analyze_apex_performance(application_id: int, days_back: int = 7) -> Dict[str, Any]:
    """
    Analisa performance de uma aplicação APEX
    
    Args:
        application_id: ID da aplicação APEX
        days_back: Número de dias para análise (padrão: 7)
    
    Returns:
        Relatório de performance com métricas e recomendações
    """
    try:
        connection = cx_Oracle.connect(DB_CONNECTION_STRING)
        cursor = connection.cursor()
        
        # Análise de sessões e page views
        performance_query = """
        SELECT 
            page_id,
            COUNT(*) as page_views,
            AVG(elapsed_time) as avg_response_time,
            MAX(elapsed_time) as max_response_time,
            COUNT(DISTINCT apex_session_id) as unique_sessions
        FROM apex_workspace_activity_log 
        WHERE application_id = :app_id 
          AND view_date >= SYSDATE - :days
        GROUP BY page_id
        ORDER BY page_views DESC
        """
        
        cursor.execute(performance_query, {
            'app_id': application_id,
            'days': days_back
        })
        
        performance_data = []
        for row in cursor.fetchall():
            performance_data.append({
                'page_id': row[0],
                'page_views': row[1],
                'avg_response_time': float(row[2]) if row[2] else 0,
                'max_response_time': float(row[3]) if row[3] else 0,
                'unique_sessions': row[4]
            })
        
        # Identificar páginas problemáticas
        slow_pages = [p for p in performance_data if p['avg_response_time'] > 2.0]
        popular_pages = sorted(performance_data, key=lambda x: x['page_views'], reverse=True)[:5]
        
        cursor.close()
        connection.close()
        
        return {
            "status": "success",
            "application_id": application_id,
            "analysis_period": f"{days_back} dias",
            "total_pages_analyzed": len(performance_data),
            "performance_data": performance_data,
            "insights": {
                "slow_pages": slow_pages,
                "popular_pages": popular_pages,
                "recommendations": [
                    "Optimizar consultas SQL em páginas com tempo de resposta > 2s",
                    "Implementar cache para páginas mais acedidas",
                    "Rever índices nas tabelas utilizadas pelas páginas lentas"
                ]
            }
        }
        
    except Exception as e:
        return {
            "status": "error",
            "message": f"Erro na análise de performance: {str(e)}"
        }

if __name__ == "__main__":
    # Verificar variáveis de ambiente necessárias
    required_env_vars = ["DB_CONNECTION_STRING"]
    missing_vars = [var for var in required_env_vars if not os.getenv(var)]
    
    if missing_vars:
        print(f"Erro: Variáveis de ambiente em falta: {', '.join(missing_vars)}")
        sys.exit(1)
    
    # Iniciar servidor MCP
    mcp.run()
```

#### **Ficheiro: mcp-servers/requirements.txt**
```txt
fastmcp>=0.2.0
httpx>=0.25.0
cx-Oracle>=8.3.0
python-dotenv>=1.0.0
asyncio-mqtt>=0.11.0
pydantic>=2.0.0
```

#### **Script de Instalação: setup.sh**
```bash
#!/bin/bash

echo "Configurando ambiente MCP para Oracle APEX..."

# Criar directório de trabalho
mkdir -p oracle-apex-mcp/mcp-servers
cd oracle-apex-mcp

# Instalar dependências Python
python -m venv venv
source venv/bin/activate
pip install -r mcp-servers/requirements.txt

# Configurar variáveis de ambiente
cat > .env << EOF
# Configuração Base de Dados
DB_CONNECTION_STRING=apex_mcp_user/Password123!@//localhost:1521/XEPDB1

# Configuração APEX
APEX_BASE_URL=https://apex.oracle.com
APEX_WORKSPACE=SEU_WORKSPACE
APEX_USERNAME=seu_username
APEX_PASSWORD=sua_password

# Configuração MCP Server
MCP_SERVER_PORT=3001
MCP_DEBUG=false
EOF

echo "Configuração concluída!"
echo "Edite o ficheiro .env com as suas credenciais antes de continuar."
```

---

## **Configuração do Gemini CLI**

### **Passo 1: Configurar settings.json**

#### **Ficheiro: ~/.gemini/settings.json**
```json
{
  "theme": "Default",
  "selectedAuthType": "oauth-personal",
  "mcpServers": {
    "oracle-sqlcl": {
      "command": "/opt/oracle/sqlcl/bin/sql",
      "args": ["-mcp"],
      "env": {
        "TNS_ADMIN": "/opt/oracle/network/admin",
        "ORACLE_HOME": "/opt/oracle",
        "NLS_LANG": "PORTUGUESE_PORTUGAL.AL32UTF8"
      },
      "timeout": 30000,
      "heartbeatInterval": 60000
    },
    "apex-custom": {
      "command": "python",
      "args": ["/path/to/oracle-apex-mcp/mcp-servers/apex-server.py"],
      "cwd": "/path/to/oracle-apex-mcp",
      "env": {
        "PYTHONPATH": "/path/to/oracle-apex-mcp",
        "DB_CONNECTION_STRING": "apex_mcp_user/Password123!@//localhost:1521/XEPDB1",
        "APEX_WORKSPACE": "SEU_WORKSPACE"
      },
      "timeout": 30000
    }
  },
  "projectInstructions": {
    "apex": {
      "description": "Projectos Oracle APEX",
      "rules": [
        "Sempre use nomenclatura consistente para páginas e itens",
        "Implemente validações adequadas em formulários",
        "Use templates padrão quando possível",
        "Documente alterações importantes"
      ],
      "codeStyle": {
        "sql": "Use UPPER CASE para palavras-chave SQL",
        "plsql": "Use convenções Oracle para nomes de variáveis",
        "apex": "Use prefixos consistentes para itens (P1_, P2_, etc.)"
      }
    }
  }
}
```

### **Passo 2: Criar Ficheiro de Projecto APEX**

#### **Ficheiro: GEMINI.md (no directório raiz do projecto)**
```markdown
# Configuração Gemini CLI para Projecto APEX

## Informações do Projecto
- **Tipo**: Aplicação Oracle APEX
- **Base de Dados**: Oracle 23ai
- **Workspace**: SEU_WORKSPACE
- **Aplicação ID**: 100

## Ferramentas Disponíveis
### Oracle SQLcl MCP Server
- `list-connections`: Lista conexões disponíveis
- `connect`: Estabelece conexão com BD
- `sql`: Executa comandos SQL
- `describe`: Descreve objectos BD

### APEX Custom MCP Server
- `list_apex_applications`: Lista aplicações APEX
- `get_apex_app_details`: Detalhes de aplicação
- `generate_apex_page_sql`: Gera código de páginas
- `export_apex_application`: Exporta aplicação
- `analyze_apex_performance`: Análise de performance

## Regras de Desenvolvimento
1. Sempre testar queries SQL antes de implementar
2. Usar templates padrão APEX quando possível
3. Implementar validações adequadas
4. Manter documentação actualizada
5. Fazer backup antes de alterações importantes

## Convenções de Nomenclatura
- **Páginas**: P{ID}_{NOME} (ex: P1_HOME, P2_CUSTOMERS)
- **Itens**: P{PAGE_ID}_{NOME} (ex: P1_USERNAME, P2_CUSTOMER_ID)  
- **Regiões**: R{ID}_{NOME} (ex: R1_CUSTOMER_LIST)
- **Processos**: PROC_{NOME} (ex: PROC_SAVE_CUSTOMER)

## Base de Dados
- **Schema Principal**: APEX_SCHEMA
- **Tabelas Core**: CUSTOMERS, PRODUCTS, ORDERS
- **Views**: V_CUSTOMER_ORDERS, V_PRODUCT_SALES
```

### **Passo 3: Inicializar e Testar**

```bash
# Iniciar Gemini CLI
gemini

# Verificar MCP servers carregados
/mcp

# Testar conexão Oracle
Conecta-te à base de dados Oracle usando a conexão mcp_apex

# Listar aplicações APEX
Lista todas as aplicações APEX no workspace

# Testar geração de código
Cria uma página de relatório para a tabela CUSTOMERS na aplicação 100
```

---

## **Exemplos Práticos de Uso**

### **Exemplo 1: Análise de Esquema de Base de Dados**

**Prompt:**
```
Analisa a estrutura das tabelas do meu projecto APEX e sugere melhorias para performance. 
Concentra-te nas tabelas CUSTOMERS, PRODUCTS e ORDERS.
```

**Resposta Esperada do Gemini CLI:**
- Conecta automaticamente via SQLcl MCP
- Executa DESCRIBE em cada tabela
- Analisa índices existentes
- Sugere optimizações baseadas em padrões de acesso

### **Exemplo 2: Geração de Página APEX**

**Prompt:**
```
Cria uma página de relatório interactivo para mostrar vendas por região no último trimestre. 
A página deve incluir filtros por data e região, e um gráfico de barras.
```

**Fluxo Esperado:**
1. Gemini CLI usa o servidor MCP APEX personalizado
2. Gera SQL optimizado para o relatório
3. Cria código PL/SQL para a página APEX
4. Sugere templates e componentes adequados

### **Exemplo 3: Optimização de Performance**

**Prompt:**
```
Analisa a performance da aplicação APEX ID 100 nos últimos 7 dias e 
sugere optimizações específicas para as páginas mais lentas.
```

**Resultado:**
- Análise automática de logs APEX
- Identificação de páginas problemáticas  
- Sugestões específicas de optimização
- SQL para implementar melhorias

### **Exemplo 4: Backup e Versionamento**

**Prompt:**
```
Exporta a aplicação APEX 100 com todas as configurações e cria um backup 
com timestamp. Inclui também as tabelas de dados principais.
```

**Acções Automáticas:**
- Export completo da aplicação
- Backup de dados das tabelas core
- Criação de ficheiro ZIP com timestamp
- Verificação de integridade do backup

---

## **Casos de Uso Avançados**

### **Desenvolvimento Colaborativo**

#### **Sincronização de Alterações**
```python
@mcp.tool()
async def sync_apex_changes(
    application_id: int, 
    since_date: str,
    developer_name: Optional[str] = None
) -> Dict[str, Any]:
    """
    Sincroniza alterações numa aplicação APEX desde uma data específica
    """
    # Implementação para detectar e sincronizar alterações
    pass
```

#### **Controlo de Versões**
```bash
# Prompt exemplo
"Cria uma nova versão da aplicação 100 marcada como v1.2.3 e 
exporta apenas os componentes alterados desde a última versão"
```

### **Integração com CI/CD**

#### **Script de Deploy Automático**
```python
@mcp.tool()
async def deploy_apex_application(
    source_app_id: int,
    target_workspace: str,
    deployment_mode: str = "development"
) -> Dict[str, Any]:
    """
    Deploy automático de aplicação APEX entre ambientes
    """
    # Lógica de deployment
    pass
```

### **Análise Avançada de Dados**

#### **Geração de Dashboards Dinâmicos**
```python
@mcp.tool()
async def create_apex_dashboard(
    data_sources: List[str],
    dashboard_type: str,
    filters: Optional[Dict] = None
) -> Dict[str, Any]:
    """
    Cria dashboard APEX baseado em análise automática de dados
    """
    # Análise de dados e geração de dashboard
    pass
```

---

## **Resolução de Problemas**

### **Problemas Comuns e Soluções**

#### **1. SQLcl MCP Server não inicia**
```bash
# Verificar Java
java -version

# Verificar SQLcl
sql -version

# Testar conexão manual
sql apex_mcp_user/password@//localhost:1521/XEPDB1

# Verificar logs
tail -f ~/.sqlcl/logs/mcp-server.log
```

#### **2. Servidor MCP Python com Erros**
```bash
# Verificar dependências
pip list | grep -E "(cx-Oracle|fastmcp)"

# Testar conexão BD
python -c "import cx_Oracle; print(cx_Oracle.connect('connection_string'))"

# Debug do servidor
python apex-server.py --debug
```

#### **3. Gemini CLI não reconhece ferramentas MCP**
```json
// Verificar settings.json
{
  "mcpServers": {
    "oracle-sqlcl": {
      "command": "/caminho/correto/para/sql",
      "args": ["-mcp"]
    }
  }
}
```

#### **4. Permissões de Base de Dados**
```sql
-- Verificar privilégios do utilizador MCP
SELECT * FROM user_sys_privs;
SELECT * FROM user_tab_privs;

-- Conceder privilégios em falta
GRANT SELECT ON apex_applications TO apex_mcp_user;
GRANT EXECUTE ON apex_export TO apex_mcp_user;
```

### **Logs e Debugging**

#### **Activar Logging Detalhado**
```bash
# SQLcl
export SQLCL_DEBUG=true

# Python MCP Server
export MCP_DEBUG=true
export PYTHONPATH=/path/to/project

# Gemini CLI
gemini --verbose
```

#### **Análise de Logs**
```bash
# Logs SQLcl MCP
tail -f ~/.sqlcl/logs/*.log

# Logs Python MCP
tail -f /tmp/apex-mcp-server.log

# Logs Gemini CLI  
tail -f ~/.gemini/logs/mcp-*.log
```

---

## **Conclusão**

Este guia fornece uma configuração completa para usar MCP com Oracle APEX e Gemini CLI, permitindo:

- **Desenvolvimento acelerado** através de linguagem natural
- **Automação** de tarefas repetitivas de desenvolvimento APEX
- **Análise inteligente** de performance e dados
- **Integração seamless** entre ferramentas Oracle e IA

### **Próximos Passos Recomendados**

1. **Implementar** a configuração básica seguindo os passos deste guia
2. **Testar** com aplicações APEX existentes
3. **Personalizar** o servidor MCP conforme necessidades específicas
4. **Expandir** funcionalidades com ferramentas adicionais
5. **Integrar** com pipelines CI/CD existentes

### **Recursos Adicionais**

- [Documentação Oracle SQLcl MCP](https://docs.oracle.com/en/database/oracle/sql-developer-command-line/25.2/sqcug/using-oracle-sqlcl-mcp-server.html)
- [API Reference Oracle APEX](https://apex.oracle.com/api)
- [Gemini CLI Documentation](https://ai.google.dev/gemini-api/docs/cli)
- [Model Context Protocol Specification](https://modelcontextprotocol.io)

---

**Última actualização:** Setembro 2025  
**Versão:** 1.0  
**Compatibilidade:** Oracle APEX 24.x, SQLcl 25.2+, Gemini CLI latest