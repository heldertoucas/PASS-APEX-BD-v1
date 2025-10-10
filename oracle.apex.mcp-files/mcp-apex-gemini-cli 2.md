# **Guia Completo e Definitivo: Configurar MCP para Oracle APEX com Gemini CLI (Ambiente macOS)**

**Um guia detalhado, passo a passo, para implementar o Model Context Protocol (MCP) e transformar a sua forma de desenvolver em Oracle APEX. Utilize o poder do Gemini CLI para interagir em linguagem natural com as suas bases de dados, aplicações e APIs, mesmo que seja a sua primeira vez a configurar um ambiente de desenvolvimento no Mac.**

-----

## **Índice**

1.  [Introdução e Conceitos Básicos](https://www.google.com/search?q=%23introdu%C3%A7%C3%A3o-e-conceitos-b%C3%A1sicos)
2.  [Pré-requisitos e Preparação do Ambiente](https://www.google.com/search?q=%23pr%C3%A9-requisitos-e-prepara%C3%A7%C3%A3o-do-ambiente)
3.  [Configuração do Oracle SQLcl MCP Server](https://www.google.com/search?q=%23configura%C3%A7%C3%A3o-do-oracle-sqlcl-mcp-server)
4.  [Criação de Servidor MCP Personalizado para APEX](https://www.google.com/search?q=%23cria%C3%A7%C3%A3o-de-servidor-mcp-personalizado-para-apex)
5.  [Configuração do Gemini CLI](https://www.google.com/search?q=%23configura%C3%A7%C3%A3o-do-gemini-cli)
6.  [Exemplos Práticos de Uso](https://www.google.com/search?q=%23exemplos-pr%C3%A1ticos-de-uso)
7.  [Resolução de Problemas](https://www.google.com/search?q=%23resolu%C3%A7%C3%A3o-de-problemas)
8.  [Casos de Uso Avançados](https://www.google.com/search?q=%23casos-de-uso-avan%C3%A7ados)
9.  [Conclusão e Próximos Passos](https://www.google.com/search?q=%23conclus%C3%A3o-e-pr%C3%B3ximos-passos)

-----

## **1. Introdução e Conceitos Básicos**

### **O que é MCP (Model Context Protocol)?**

Pense no Model Context Protocol como um tradutor universal e seguro que permite que modelos de Inteligência Artificial, como o Gemini, conversem com as suas ferramentas de trabalho. Em vez de a IA apenas "saber" coisas, ela passa a "fazer" coisas. No nosso caso, damos ao Gemini CLI a capacidade de:

  - **Executar SQL:** Consultar e manipular dados diretamente na sua base de dados Oracle.
  - **Entender APEX:** Aceder a metadados para saber que aplicações, páginas e componentes existem.
  - **Automatizar Tarefas:** Gerar páginas, componentes e até exportar aplicações com um simples pedido.
  - **Interagir com APIs:** Chamar serviços REST para integrar com outros sistemas.
  - **Garantir Segurança:** Manter um registo de auditoria completo de todas as operações.

### **Arquitectura da Solução**

A nossa configuração funciona como uma equipa de especialistas bem coordenada:

```
┌─────────────────┐      ┌──────────────────┐      ┌─────────────────┐
│                 │◄────►│                  │◄────►│                 │
│   Gemini CLI    │      │   MCP Servers    │      │ Oracle Database │
│(O seu Assistente)│      │  (Os Tradutores) │      │   + APEX        │
│                 │      │                  │      │(A Fonte da Verdade)│
│- Interface de Chat│      │- SQLcl (para SQL)│      │                 │
│- Chamada a Ferramentas│      │- Python (para APEX)│      │- Aplicações     │
│- Gestão de Permissões│      │- APIs REST       │      │- Metadados      │
└─────────────────┘      └──────────────────┘      └─────────────────┘
```

1.  **Você** conversa com o **Gemini CLI** em português corrente.
2.  O **Gemini CLI** percebe a sua intenção e ativa a ferramenta certa num dos **MCP Servers**.
3.  Os **MCP Servers** executam a ação de forma segura e precisa no **Oracle Database + APEX**.

-----

## **2. Pré-requisitos e Preparação do Ambiente**

### **Software Necessário**

  - **Oracle Database 23ai ou superior** (usaremos Docker para simplificar).
  - **Oracle SQLcl 25.2 ou superior**.
  - **Oracle Instant Client** (bibliotecas de conexão).
  - **Java Runtime Environment (JRE) 17 ou superior**.
  - **Gemini CLI** (versão mais recente).
  - **Python 3.9+** e **pip**.
  - **Docker Desktop**.
  - **Homebrew** (o gestor de pacotes para macOS).

### **Guia Detalhado: Instalação e Configuração em macOS**

Vamos configurar o seu Mac do zero. Abra a aplicação **Terminal** (`Aplicações > Utilitários`).

#### **Passo 1: Instalar o Homebrew**

Se não tiver o Homebrew, o "canivete suíço" para developers em macOS, instale-o com este comando:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

#### **Passo 2: Instalar Java, Python e Ferramentas Auxiliares**

Com o Homebrew, um comando instala quase tudo o que precisamos:

```bash
brew install openjdk@17 python wget
```

#### **Passo 3: Instalar o Gemini CLI**

A Google fornece um instalador simples. Feche e reabra o terminal após a instalação.

```bash
curl -s -L https://ai.google.dev/gemini-api/install.sh | bash
gemini --version # Para verificar
```

#### **Passo 4: Instalar e Configurar o Docker e a Base de Dados Oracle**

1.  **Instale o Docker Desktop:** Baixe e instale a partir do [site oficial do Docker](https://www.docker.com/products/docker-desktop/).
2.  **Inicie o Docker Desktop** a partir da sua pasta de Aplicações.
3.  **Execute o contentor da Base de Dados Oracle Free:** Este comando irá baixar e iniciar a base de dados.
    ```bash
    docker run -d --name oracle-db -p 1521:1521 -e ORACLE_RANDOM_PASSWORD=yes gvenzl/oracle-free
    ```
4.  **Obtenha a sua password de administrador (SYS):**
    ```bash
    docker logs oracle-db 2>&1 | grep "PASSWORD FOR SYS:"
    ```
    **Anote esta password\! É crucial.**

#### **Passo 5: Baixar e Configurar o Software Oracle**

1.  **Crie uma pasta dedicada:**
    ```bash
    mkdir -p ~/lib/oracle
    ```
2.  **Baixe os ficheiros ZIP:**
      * **Instant Client (Basic Package):** [Página de Downloads](https://www.oracle.com/database/technologies/instant-client/macos-intel-x86-downloads.html)
      * **SQLcl:** [Página de Downloads](https://www.oracle.com/database/sqldeveloper/technologies/sqlcl/download/)
3.  **Extraia os ficheiros:** Mova os ZIPs para `~/lib/oracle` e extraia-os.
    ```bash
    # (Ajuste os nomes dos ficheiros conforme as versões que baixou)
    unzip ~/Downloads/instantclient-basic-macos*.zip -d ~/lib/oracle/
    unzip ~/Downloads/sqlcl-*.zip -d ~/lib/oracle/
    ```

#### **Passo 6: Configurar as Variáveis de Ambiente**

Edite o ficheiro de configuração do seu terminal para que ele saiba onde encontrar tudo.

```bash
nano ~/.zshrc
```

Adicione o seguinte ao final do ficheiro. **Verifique e ajuste o nome da pasta `instantclient_XX_X`\!**

```bash
# --- Configuração Oracle & Java ---
export JAVA_HOME=$(/usr/libexec/java_home -v17)
export PATH="$JAVA_HOME/bin:$PATH"

export ORACLE_HOME=~/lib/oracle/instantclient_19_8 # <-- VERIFIQUE ESTE NOME
export DYLD_LIBRARY_PATH="$ORACLE_HOME"

export PATH="~/lib/oracle/sqlcl/bin:$PATH"
# --- Fim da Configuração ---
```

Guarde (`Ctrl+X`, `Y`, `Enter`) e aplique as alterações: `source ~/.zshrc`.

#### **Passo 7: Verificar o Ambiente**

Confirme que cada peça está no seu lugar.

```bash
java -version
python3 --version
gemini --version
sql -version
pip3 install python-oracledb[thick] # Instala o driver de BD para Python
```

Se não houver erros, o seu ambiente está pronto\!

-----

## **3. Configuração do Oracle SQLcl MCP Server**

### **Passo 1: Criar um Utilizador Dedicado na Base de Dados**

1.  **Conecte-se como SYS** usando a password do Docker.
    ```bash
    sql sys@//localhost:1521/FREEPDB1 as sysdba
    ```
2.  **Execute o script SQL para criar o nosso utilizador:**
    ```sql
    CREATE USER apex_mcp_user IDENTIFIED BY "YourSecurePassword123!";
    GRANT CONNECT, RESOURCE, APEX_ADMINISTRATOR_ROLE TO apex_mcp_user;
    GRANT SELECT ANY TABLE, CREATE ANY TABLE, ALTER ANY TABLE TO apex_mcp_user;
    GRANT EXECUTE ON DBMS_METADATA TO apex_mcp_user;
    ALTER USER apex_mcp_user QUOTA UNLIMITED ON users;
    exit
    ```

### **Passo 2: Salvar a Conexão no SQLcl**

```bash
sql /nolog
SQL> connect apex_mcp_user/YourSecurePassword123!@//localhost:1521/FREEPDB1
SQL> conn -save mcp_apex -savepwd apex_mcp_user/YourSecurePassword123!@//localhost:1521/FREEPDB1
SQL> conn -list
exit
```

### **Passo 3: Testar o Servidor MCP Embutido do SQLcl**

1.  **Num terminal, inicie o servidor:** `sql -mcp`
2.  **Noutro terminal, teste a conectividade:** `curl -X POST http://localhost:3000/mcp/tools`

Se receber uma resposta JSON com uma lista de ferramentas, funcionou\! Pode parar o servidor com `Ctrl+C`.

-----

## **4. Criação de Servidor MCP Personalizado para APEX**

Este servidor Python será o nosso especialista em APEX.

#### **Ficheiro: `mcp-servers/requirements.txt`**

```txt
fastmcp>=0.2.0
python-oracledb[thick]>=2.0.0
python-dotenv>=1.0.0
pydantic>=2.0.0
```

#### **Ficheiro: `mcp-servers/apex-server.py` (Versão Completa e Atualizada)**

Este código foi totalmente modernizado para usar `python-oracledb`.

```python
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
```

-----

## **5. Configuração do Gemini CLI**

#### **Ficheiro de Configuração: `~/.gemini/settings.json`**

Crie este ficheiro se não existir (`mkdir -p ~/.gemini && nano ~/.gemini/settings.json`). **Ajuste os caminhos** para o seu utilizador e estrutura de pastas.

```json
{
  "theme": "Default",
  "selectedAuthType": "oauth-personal",
  "mcpServers": {
    "oracle-sqlcl": {
      "command": "sql",
      "args": ["-mcp"],
      "env": {
        "DYLD_LIBRARY_PATH": "/Users/SEU_UTILIZADOR/lib/oracle/instantclient_19_8"
      },
      "timeout": 30000
    },
    "apex-custom": {
      "command": "/Users/SEU_UTILIZADOR/caminho/para/oracle-apex-mcp/venv/bin/python",
      "args": ["/Users/SEU_UTILIZADOR/caminho/para/oracle-apex-mcp/mcp-servers/apex-server.py"],
      "cwd": "/Users/SEU_UTILIZADOR/caminho/para/oracle-apex-mcp",
      "env": {
        "DB_PASSWORD": "YourSecurePassword123!"
      },
      "timeout": 30000
    }
  }
}
```

#### **Ficheiro de Projeto: `GEMINI.md`**

Crie este ficheiro na raiz da sua pasta do projeto. Ele dá o contexto ao Gemini.

```markdown
# Configuração Gemini CLI para Projeto APEX

## Informações do Projeto
- **Tipo**: Aplicação Oracle APEX
- **Base de Dados**: Oracle (via Docker)
- **Serviço**: FREEPDB1

## Ferramentas Disponíveis
### Oracle SQLcl MCP Server
- `sql`: Executa comandos SQL e PL/SQL.
- `describe`: Descreve tabelas, views, etc.

### APEX Custom MCP Server
- `list_apex_applications`: Lista todas as aplicações APEX.
- `get_apex_app_details`: Obtém detalhes (páginas, itens) de uma app.
- `generate_apex_page_sql`: Gera um template SQL para criar páginas.
- `export_apex_application`: Exporta uma aplicação para um ficheiro SQL.
- `analyze_apex_performance`: Analisa os logs de performance do APEX.

## Regras de Desenvolvimento
- Usar sempre `UPPERCASE` para palavras-chave SQL.
- Prefixo de itens de página: `P<PAGE_ID>_<ITEM_NAME>`.
- Fazer backup da aplicação antes de aplicar alterações significativas.
```

-----

## **6. Exemplos Práticos de Uso**

Inicie o Gemini CLI na pasta do seu projeto (`cd /caminho/para/oracle-apex-mcp` e depois `gemini`).

  * **Verificar Servidores:** `/mcp` (devem aparecer `CONNECTED`)
  * **Prompt 1: Análise de Estrutura**
    > `Descreve a tabela EMP usando o sqlcl.`
  * **Prompt 2: Obter Informação do APEX**
    > `Quais são as aplicações APEX disponíveis? Fornece o ID e o nome.`
  * **Prompt 3: Análise de Performance**
    > `Analisa a performance da aplicação 100 nos últimos 30 dias e diz-me se há páginas lentas.`
  * **Prompt 4: Exportar uma Aplicação**
    > `Exporta a aplicação APEX com o ID 100.`

-----

## **7. Resolução de Problemas**

| Problema                               | Solução                                                                                                                                                             |
| -------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **SQLcl MCP não inicia** | Verifique a sua instalação Java (`java -version`). Teste a conexão manual ao seu Docker DB. Verifique os logs em `~/.sqlcl/logs/`.                                    |
| **Servidor Python com erros** | Ative o seu ambiente virtual (`source venv/bin/activate`). Verifique se `python-oracledb` está instalado (`pip list`). Confirme que a `DB_PASSWORD` está definida.    |
| **Gemini CLI não encontra ferramentas** | Verifique os caminhos no seu `~/.gemini/settings.json`. Certifique-se de que correspondem exatamente à sua estrutura de pastas. Use `pwd` para confirmar os caminhos. |
| **Permissões de Base de Dados** | Conecte-se como `SYS` e verifique se o `apex_mcp_user` tem os `GRANTs` necessários, especialmente para aceder às views `APEX_...` e ao pacote `APEX_EXPORT`.          |
| **Erro `DPI-1047` (Python)** | Este erro significa que o `python-oracledb` não encontrou o Instant Client. Confirme que as variáveis `ORACLE_HOME` e `DYLD_LIBRARY_PATH` estão corretas no `.zshrc`. |

-----

## **8. Casos de Uso Avançados**

Com a base estabelecida, pode expandir as capacidades do seu assistente:

  - **Desenvolvimento Colaborativo:** Crie uma ferramenta que lê o log de alterações do APEX e gera um relatório diário de quem alterou o quê.
  - **Integração com CI/CD:** Desenvolva uma ferramenta `deploy_apex_application` que exporta uma app de um ambiente e a importa noutro, automatizando o processo de deployment.
  - **Análise Avançada de Dados:** Crie uma ferramenta que, dado um nome de tabela, usa IA para analisar as colunas e sugere automaticamente a criação de um dashboard APEX com gráficos relevantes.

-----

## **9. Conclusão e Próximos Passos**

Parabéns\! Você construiu uma poderosa ponte entre a linguagem natural e o desenvolvimento em Oracle APEX. Este sistema não só acelera tarefas rotineiras, como abre a porta a novas formas de interagir com o seu ecossistema de desenvolvimento.

### **Próximos Passos Recomendados:**

1.  **Experimente:** Use os exemplos práticos para se familiarizar com o fluxo de trabalho.
2.  **Personalize:** Adicione as suas próprias ferramentas ao servidor Python. Precisa de verificar standards de código? Criar dados de teste? Automatize-o\!
3.  **Expanda:** Integre com outras ferramentas, como Git, para versionar as suas exportações de aplicações automaticamente.
4.  **Integre:** Incorpore este assistente no seu pipeline de CI/CD para validações e deployments automáticos.

O potencial está limitado apenas pela sua imaginação. Bem-vindo ao futuro do desenvolvimento assistido por IA\!go