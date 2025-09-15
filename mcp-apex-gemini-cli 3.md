# **Informações Específicas Necessárias para Configurar o MCP**

Para implementar o MCP com sua aplicação APEX actual, precisa de fornecer as seguintes informações específicas:

## **1. Informações de Conexão à Base de Dados**

### **Detalhes de Conexão Oracle**
```bash
# Informação essencial necessária:
DB_HOST=seu-servidor-oracle.com          # Ex: localhost, 192.168.1.100
DB_PORT=1521                             # Porta padrão Oracle
DB_SERVICE_NAME=XEPDB1                   # Ou SID da sua base de dados
DB_SCHEMA=seu_schema_apex                # Schema onde estão as tabelas APEX

# Formato completo da connection string:
DB_CONNECTION_STRING="username/password@//host:port/service_name"
# Exemplo: "apex_user/Password123!@//localhost:1521/XEPDB1"
```

### **Identificar Informações da Sua Base de Dados**
Execute estas queries na sua base de dados para obter os detalhes necessários:

```sql
-- 1. Identificar versão APEX e esquema
SELECT * FROM apex_release;
SELECT DISTINCT owner FROM all_objects WHERE object_name LIKE 'WWV_%';

-- 2. Listar workspaces APEX disponíveis
SELECT workspace_id, workspace FROM apex_workspaces;

-- 3. Identificar o seu utilizador/schema actual
SELECT user FROM dual;
SELECT username FROM user_users;

-- 4. Verificar service name/SID
SELECT name, value FROM v$parameter WHERE name = 'service_names';
SELECT instance_name FROM v$instance;
```

## **2. Informações do Workspace APEX**

### **Detalhes do Workspace**
```bash
# Informações que precisa de fornecer:
APEX_WORKSPACE_NAME="SEU_WORKSPACE"      # Nome do workspace APEX
APEX_WORKSPACE_ID="12345"               # ID numérico do workspace
APEX_ADMIN_USERNAME="admin"              # Username de administrador APEX
APEX_ADMIN_PASSWORD="sua_password"       # Password do administrador
```

### **Descobrir Informações do Workspace**
```sql
-- Query para identificar o seu workspace
SELECT 
    workspace_id,
    workspace,
    workspace_display_name,
    provisioning_company_id
FROM apex_workspaces 
WHERE workspace = 'SEU_WORKSPACE_NAME';

-- Listar utilizadores do workspace
SELECT 
    user_name,
    first_name,
    last_name,
    email,
    admin_roles
FROM apex_workspace_apex_users 
WHERE workspace_name = 'SEU_WORKSPACE';
```

## **3. Informações da Aplicação APEX Actual**

### **Metadados da Aplicação**
```bash
# Para cada aplicação que quer gerir:
APEX_APPLICATION_ID="100"               # ID da aplicação (número)
APEX_APPLICATION_NAME="MinhApp"         # Nome da aplicação
APEX_APPLICATION_ALIAS="minhapp"        # Alias da aplicação
```

### **Descobrir Detalhes das Aplicações**
```sql
-- Listar todas as aplicações no seu workspace
SELECT 
    application_id,
    application_name,
    alias,
    version,
    build_status,
    created_by,
    created_on
FROM apex_applications 
WHERE workspace = 'SEU_WORKSPACE'
ORDER BY application_id;

-- Listar páginas de uma aplicação específica
SELECT 
    page_id,
    page_name,
    page_title,
    page_mode,
    page_template
FROM apex_application_pages 
WHERE application_id = 100  -- Substitua pelo seu APP_ID
ORDER BY page_id;
```

## **4. Estrutura das Suas Tabelas**

### **Tabelas Principais da Aplicação**
```bash
# Liste as tabelas principais que a aplicação usa:
MAIN_TABLES="CUSTOMERS,PRODUCTS,ORDERS"  # Tabelas core da aplicação
VIEW_TABLES="V_CUSTOMER_ORDERS"          # Views importantes
SCHEMA_PREFIX="APEX_USER"                # Prefixo do schema (se aplicável)
```

### **Descobrir Tabelas Utilizadas**
```sql
-- Identificar tabelas utilizadas pela aplicação APEX
SELECT DISTINCT 
    referenced_table_name,
    referenced_schema_name
FROM apex_application_pages p,
     apex_application_page_regions r
WHERE p.application_id = r.application_id
  AND p.page_id = r.page_id  
  AND p.application_id = 100  -- Seu APP_ID
  AND r.source_type LIKE '%SQL%'
  AND referenced_table_name IS NOT NULL;

-- Listar todas as tabelas no seu schema
SELECT table_name, num_rows, tablespace_name
FROM user_tables
ORDER BY table_name;
```

## **5. Ficheiros de Configuração Necessários**

### **Criar Ficheiro .env**
```bash
# Ficheiro: /path/to/oracle-apex-mcp/.env
# ============================================

# Base de Dados Oracle
DB_HOST=localhost
DB_PORT=1521
DB_SERVICE_NAME=XEPDB1
DB_USERNAME=apex_mcp_user
DB_PASSWORD=Password123!
DB_CONNECTION_STRING=apex_mcp_user/Password123!@//localhost:1521/XEPDB1

# Workspace APEX
APEX_WORKSPACE=SEU_WORKSPACE
APEX_WORKSPACE_ID=12345
APEX_ADMIN_USERNAME=admin
APEX_ADMIN_PASSWORD=sua_password
APEX_BASE_URL=https://apex.oracle.com

# Aplicação Principal
APEX_APPLICATION_ID=100
APEX_APPLICATION_NAME=MinhaApp

# Caminhos de Sistema
ORACLE_HOME=/opt/oracle
TNS_ADMIN=/opt/oracle/network/admin
SQLCL_PATH=/opt/oracle/sqlcl/bin/sql

# MCP Server Configuration
MCP_SERVER_PORT=3001
MCP_DEBUG=false
```

### **Actualizar settings.json do Gemini CLI**
```json
{
  "mcpServers": {
    "oracle-sqlcl": {
      "command": "/opt/oracle/sqlcl/bin/sql",
      "args": ["-mcp"],
      "env": {
        "TNS_ADMIN": "/opt/oracle/network/admin",
        "ORACLE_HOME": "/opt/oracle",
        "DB_CONNECTION": "apex_mcp_user/Password123!@//localhost:1521/XEPDB1"
      }
    },
    "apex-custom": {
      "command": "python",
      "args": ["/path/to/oracle-apex-mcp/mcp-servers/apex-server.py"],
      "cwd": "/path/to/oracle-apex-mcp",
      "env": {
        "DB_CONNECTION_STRING": "apex_mcp_user/Password123!@//localhost:1521/XEPDB1",
        "APEX_WORKSPACE": "SEU_WORKSPACE",
        "APEX_APPLICATION_ID": "100"
      }
    }
  }
}
```

## **6. Permissões e Segurança**

### **Utilizador MCP Dedicado**
Crie um utilizador específico para o MCP com permissões controladas:

```sql
-- 1. Criar utilizador MCP
CREATE USER apex_mcp_user IDENTIFIED BY "Password123!";

-- 2. Permissões básicas
GRANT CONNECT, RESOURCE TO apex_mcp_user;

-- 3. Permissões APEX (ajustar conforme necessário)
GRANT APEX_ADMINISTRATOR_ROLE TO apex_mcp_user;
GRANT SELECT ON apex_workspaces TO apex_mcp_user;
GRANT SELECT ON apex_applications TO apex_mcp_user;
GRANT SELECT ON apex_application_pages TO apex_mcp_user;

-- 4. Permissões nas suas tabelas específicas
GRANT SELECT, INSERT, UPDATE, DELETE ON seu_schema.CUSTOMERS TO apex_mcp_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON seu_schema.PRODUCTS TO apex_mcp_user;
-- Repita para todas as tabelas principais

-- 5. Permissões para exportar aplicações
GRANT EXECUTE ON apex_export TO apex_mcp_user;
GRANT EXECUTE ON dbms_metadata TO apex_mcp_user;
```

## **7. Informação do Seu Ambiente**

### **Detalhes do Sistema**
```bash
# Informações que precisa de verificar/fornecer:

# Versão Oracle Database
SELECT banner FROM v$version WHERE banner LIKE 'Oracle%';

# Versão APEX instalada
SELECT version FROM apex_release;

# Localização dos executáveis
which sql          # Localização SQLcl
which python       # Localização Python
which gemini       # Localização Gemini CLI

# Variáveis de ambiente actuais
echo $ORACLE_HOME
echo $TNS_ADMIN
echo $PATH
```

## **8. Configuração Específica do Projecto**

### **Ficheiro GEMINI.md personalizado**
```markdown
# Projecto APEX - [NOME_DO_SEU_PROJECTO]

## Informações da Base de Dados
- **Host**: localhost:1521
- **Service**: XEPDB1
- **Schema**: SEU_SCHEMA
- **Workspace**: SEU_WORKSPACE

## Aplicação Principal
- **ID**: 100
- **Nome**: MinhaAplicação
- **Versão**: 1.0

## Tabelas Principais
- CUSTOMERS: Gestão de clientes
- PRODUCTS: Catálogo de produtos  
- ORDERS: Gestão de encomendas
- ORDER_ITEMS: Detalhes das encomendas

## Convenções Específicas
- Prefixo páginas: P{ID}_
- Prefixo itens: P{PAGE}_{NOME}
- Prefixo processos: PROC_{NOME}
```

## **9. Script de Descoberta Automática**

Para facilitar a recolha de informações, pode executar este script:

```sql
-- Script para descobrir informações da sua configuração APEX
-- Salve como 'discover_apex_config.sql' e execute

SPOOL apex_config_discovery.txt

PROMPT ========================================
PROMPT INFORMAÇÕES DA BASE DE DADOS
PROMPT ========================================
SELECT 'DB_VERSION: ' || banner FROM v$version WHERE banner LIKE 'Oracle%';
SELECT 'INSTANCE_NAME: ' || instance_name FROM v$instance;
SELECT 'SERVICE_NAMES: ' || value FROM v$parameter WHERE name = 'service_names';

PROMPT ========================================  
PROMPT INFORMAÇÕES APEX
PROMPT ========================================
SELECT 'APEX_VERSION: ' || version FROM apex_release;
SELECT 'APEX_SCHEMA: ' || owner FROM all_objects WHERE object_name = 'WWV_FLOW_APPLICATIONS' AND ROWNUM = 1;

PROMPT ========================================
PROMPT WORKSPACES DISPONÍVEIS
PROMPT ========================================
SELECT 'WORKSPACE_ID: ' || workspace_id || ', NAME: ' || workspace FROM apex_workspaces;

PROMPT ========================================
PROMPT APLICAÇÕES NO SEU WORKSPACE
PROMPT ========================================  
SELECT 'APP_ID: ' || application_id || ', NAME: ' || application_name || ', WORKSPACE: ' || workspace 
FROM apex_applications 
WHERE workspace = 'SEU_WORKSPACE'  -- SUBSTITUIR pelo seu workspace
ORDER BY application_id;

PROMPT ========================================
PROMPT TABELAS NO SEU SCHEMA
PROMPT ========================================
SELECT 'TABLE: ' || table_name || ', ROWS: ' || NVL(num_rows, 0)
FROM user_tables 
ORDER BY table_name;

SPOOL OFF
```

## **10. Checklist de Verificação**

Antes de configurar o MCP, confirme que tem:

- [ ] **Informações de conexão** completas da base de dados
- [ ] **Nome e ID do workspace** APEX
- [ ] **ID da aplicação** principal que quer gerir
- [ ] **Credenciais de admin** APEX válidas
- [ ] **Lista das tabelas** principais utilizadas
- [ ] **SQLcl 25.2+** instalado e configurado
- [ ] **Gemini CLI** instalado e autenticado
- [ ] **Permissões adequadas** na base de dados
- [ ] **Caminhos correctos** para todos os executáveis