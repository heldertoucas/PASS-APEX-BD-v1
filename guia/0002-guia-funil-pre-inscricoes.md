# Guia de Implementação: Funil de Entrada Inteligente

**Versão:** 1.0
**Autor:** Gemini
**Propósito:** Este documento fornece um guia passo a passo para implementar a funcionalidade "Funil de Entrada Inteligente", destinada ao perfil de **Técnico**. O guia consolida os requisitos do PRD, as lições aprendidas durante o desenvolvimento e o código final e otimizado.

---

## 1. Objetivo e Pré-requisitos

O objetivo é criar um fluxo de trabalho eficiente e à prova de erros para processar novas pré-inscrições, evitando a criação de registos duplicados de cidadãos. A funcionalidade permitirá o processamento individual e em lote.

#### **Pré-requisitos:**

1.  **Pacote de Segurança (`SEGURANCA_PKG`):** É necessário ter o pacote de segurança que contém a função `is_tecnico` para proteger as páginas.
2.  **Pacote de Utilitários (`APP_UTIL_PKG`):** É fundamental ter o pacote que contém a lógica para verificar a existência de um pré-inscrito. Se não existir, crie-o em **SQL Workshop > Object Browser** com o seguinte código:

    ```sql
    -- Package Specification
    CREATE OR REPLACE PACKAGE APP_UTIL_PKG AS
        FUNCTION is_pre_inscrito_novo(
            p_nif IN PRE_INSCRICOES.NIF%TYPE, 
            p_email IN PRE_INSCRICOES.EMAIL%TYPE
        ) RETURN VARCHAR2;
    END APP_UTIL_PKG;
    /

    -- Package Body
    CREATE OR REPLACE PACKAGE BODY APP_UTIL_PKG AS
        FUNCTION is_pre_inscrito_novo(
            p_nif IN PRE_INSCRICOES.NIF%TYPE, 
            p_email IN PRE_INSCRICOES.EMAIL%TYPE
        ) RETURN VARCHAR2 AS
            v_count NUMBER;
        BEGIN
            SELECT COUNT(*) INTO v_count 
            FROM INSCRITOS 
            WHERE NIF = p_nif OR EMAIL = p_email;
            
            IF v_count > 0 THEN
                RETURN 'N'; -- Not new
            ELSE
                RETURN 'S'; -- Is new
            END IF;
        END is_pre_inscrito_novo;
    END APP_UTIL_PKG;
    /
    ```

---

## 2. Passo 1: Criar a Página Principal (Novas Pré-Inscrições)

Esta página será a "caixa de entrada" do Técnico, usando uma Grelha Interativa (Interactive Grid) para permitir a seleção múltipla.

1.  **Criar a Página:**
    *   No App Builder, clique em **Create Page** > **Interactive Grid**.
    *   **Page Name:** `Novas Pré-Inscrições`.
    *   **Navigation:** Ative a opção **Create a navigation menu entry**.

2.  **Definir a Fonte de Dados (SQL Query):**
    *   Escolha a opção **SQL Query** e cole o seguinte código. Este código já invoca a nossa função de verificação para criar a coluna `IS_NOVO`.
        ```sql
        SELECT 
            p.ID_PRE_INSCRICAO,
            p.NOME_COMPLETO,
            p.EMAIL,
            p.CONTACTO_TELEFONICO,
            p.NIF,
            APP_UTIL_PKG.is_pre_inscrito_novo(p.NIF, p.EMAIL) as IS_NOVO
        FROM
            PRE_INSCRICOES p
        WHERE
            p.ID_ESTADO_PRE_INSCRICAO = 1 -- Status: 'Nova'
        ```

3.  **Configurar a Grelha:**
    *   **Segurança:** Na página criada, selecione o nó principal e em **Security > Authorization Scheme**, aplique o esquema `is_tecnico`.
    *   **Coluna de Tags Visuais:**
        *   No painel "Rendering", encontre a coluna `IS_NOVO`.
        *   Altere o seu **Type** para **HTML Expression**.
        *   No campo **HTML Expression**, cole o seguinte código para mostrar um badge colorido:
            ```html
            <span style="padding: 3px 6px; border-radius: 4px; color: white; background-color: #IS_NOVO#;">
              #IS_NOVO#
            </span>
            ```
        *   Para que as cores funcionem, crie uma coluna adicional na sua SQL Query para o `CASE`:
            ```sql
            -- Adicione esta coluna à sua query
            CASE APP_UTIL_PKG.is_pre_inscrito_novo(p.NIF, p.EMAIL)
                WHEN 'S' THEN 'green'
                ELSE 'orange'
            END as TAG_COLOR,
            -- Mude a coluna IS_NOVO para:
            CASE APP_UTIL_PKG.is_pre_inscrito_novo(p.NIF, p.EMAIL)
                WHEN 'S' THEN 'NOVO'
                ELSE 'EXISTENTE'
            END as IS_NOVO
            ```
        *   Atualize a **HTML Expression** para usar a nova coluna de cor: `... background-color: #TAG_COLOR#; ...`
        *   Na coluna `IS_NOVO`, em **Security**, **DESLIGUE** a opção `Escape special characters`.
    *   **Link para o Modal:**
        *   Crie uma nova coluna virtual na grelha do tipo **Link**.
        *   Configure o **Target** para apontar para a sua página modal (que criará no próximo passo), passando o `ID_PRE_INSCRICAO` como parâmetro.

---

## 3. Passo 2: Criar o Formulário Modal (Processar Pré-Inscrição)

1.  **Criar a Página:**
    *   Crie uma nova página do tipo **Form** com o **Page Mode** definido como **Modal Dialog**.
    *   **Name:** `Processar Pré-Inscrição`.
    *   **Navigation:** Certifique-se de que a entrada de menu está **DESATIVADA**.
    *   **Data Source:** Baseie o formulário na tabela `INSCRITOS`.

2.  **Configurar Itens e Botões:**
    *   No Page Designer, crie os seguintes itens **Hidden**:
        *   `P<ID>_ID_PRE_INSCRICAO`: Para receber o ID da linha clicada.
        *   `P<ID>_MODO`: Para controlar se o formulário está em modo `CREATE` ou `UPDATE`.
    *   Crie dois botões no rodapé:
        *   `CRIAR`: Com a **Server-Side Condition** do tipo `Item = Value`, Item: `P<ID>_MODO`, Value: `CREATE`.
        *   `GUARDAR`: Com a **Server-Side Condition** do tipo `Item = Value`, Item: `P<ID>_MODO`, Value: `UPDATE`.

---

## 4. Passo 3: Implementar a Lógica de Processamento Individual

1.  **Criar o Processo de Pré-Rendering:**
    *   Na página modal, no separador **Processing**, crie um processo em **Before Header**.
    *   **Name:** `Verificar Existência e Pré-preencher`
    *   **Type:** `Execute Code`
    *   **PL/SQL Code:** Cole o código final e corrigido. Este código verifica se o cidadão existe e pré-preenche os dados ou carrega o registo existente.
        ```sql
        DECLARE
            v_pre_insc PRE_INSCRICOES%ROWTYPE;
            v_inscrito_id INSCRITOS.ID_INSCRITO%TYPE;
        BEGIN
            -- 1. Obter os dados da pré-inscrição que foi clicada
            SELECT * INTO v_pre_insc FROM PRE_INSCRICOES WHERE ID_PRE_INSCRICAO = :P<ID>_ID_PRE_INSCRICAO;
            
            -- 2. Tentar encontrar um inscrito com o mesmo NIF ou Email
            BEGIN
                SELECT ID_INSCRITO INTO v_inscrito_id
                FROM INSCRITOS
                WHERE NIF = v_pre_insc.NIF OR EMAIL = v_pre_insc.EMAIL;
                
                -- 3a. Se ENCONTROU, entramos em modo de ATUALIZAÇÃO
                :P<ID>_MODO := 'UPDATE';
                :P<ID>_ID_INSCRITO := v_inscrito_id; -- Define a chave primária para o APEX carregar o registo
                
                apex_error.add_error(
                    p_message          => 'Atenção: Já existe um inscrito com este NIF ou Email. Por favor, verifique e atualize os dados existentes.',
                    p_display_location => apex_error.c_inline_in_notification
                );
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    -- 3b. Se NÃO ENCONTROU, entramos em modo de CRIAÇÃO
                    :P<ID>_MODO := 'CREATE';
                    
                    -- Pré-preenchemos os campos essenciais do formulário
                    :P<ID>_NOME_COMPLETO     := v_pre_insc.NOME_COMPLETO;
                    :P<ID>_EMAIL              := v_pre_insc.EMAIL;
                    :P<ID>_CONTACTO_TELEFONICO := v_pre_insc.CONTACTO_TELEFONICO;
                    :P<ID>_NIF                := v_pre_insc.NIF;
                    :P<ID>_DATA_NASCIMENTO    := v_pre_insc.DATA_NASCIMENTO;
            END;
        END;
        ```

2.  **Criar o Processo Final de Atualização:**
    *   Crie um processo **After Submit** que corre depois do processamento automático do formulário.
    *   **Name:** `Atualizar Estado da Pré-Inscrição`
    *   **Type:** `Execute Code`
    *   **PL/SQL Code:**
        ```sql
        UPDATE PRE_INSCRICOES
           SET ID_ESTADO_PRE_INSCRICAO = 3 -- ID para "Convertida"
         WHERE ID_PRE_INSCRICAO = :P<ID>_ID_PRE_INSCRICAO;
        ```

---

## 5. Passo 4: Implementar o Processamento em Lote

1.  **Adicionar o Botão de Ação:**
    *   Na página da Grelha Interativa, adicione um botão na região do relatório.
    *   **Button Name:** `PROCESSAR_LOTE`
    *   **Label:** `Processar Selecionados em Lote`
    *   **Action:** `Submit Page`

2.  **Criar o Processo de Lote:**
    *   No separador **Processing** da página da grelha, crie um novo processo.
    *   **Name:** `Processar Lote`
    *   **Type:** `PL/SQL Code`
    *   **Server-Side Condition > When Button Pressed:** Selecione o seu botão `PROCESSAR_LOTE`.
    *   **PL/SQL Code:** Cole o código final e otimizado. Este código itera apenas sobre as linhas selecionadas e processa apenas as que são novas.
        ```sql
        DECLARE
            v_pre_insc PRE_INSCRICOES%ROWTYPE;
            v_existing_count NUMBER;
        BEGIN
            -- O APEX coloca os IDs das linhas selecionadas no array G_F01
            IF apex_application.g_f01.COUNT = 0 THEN
                RETURN; -- Não faz nada se nenhuma linha for selecionada
            END IF;
        
            -- Itera sobre todos os IDs selecionados
            FOR i IN 1..apex_application.g_f01.COUNT LOOP
                DECLARE
                    l_pre_inscricao_id PRE_INSCRICOES.ID_PRE_INSCRICAO%TYPE := TO_NUMBER(apex_application.g_f01(i));
                BEGIN
                    SELECT * INTO v_pre_insc FROM PRE_INSCRICOES WHERE ID_PRE_INSCRICAO = l_pre_inscricao_id;
        
                    SELECT COUNT(*) INTO v_existing_count FROM INSCRITOS WHERE NIF = v_pre_insc.NIF OR Email = v_pre_insc.EMAIL;
        
                    -- Apenas processa se for um cidadão NOVO
                    IF v_existing_count = 0 THEN
                        INSERT INTO Inscritos (Nome_Completo, Email, Contacto_Telefonico, NIF, Data_Nascimento, ID_Estado_Geral_Inscrito, Origem_Inscricao) 
                        VALUES (v_pre_insc.Nome_Completo, v_pre_insc.Email, v_pre_insc.Contacto_Telefonico, v_pre_insc.NIF, v_pre_insc.Data_Nascimento, 1, 'Formulário Online (Lote)');
        
                        UPDATE PRE_INSCRICOES SET ID_ESTADO_PRE_INSCRICAO = 3 WHERE ID_PRE_INSCRICAO = l_pre_inscricao_id;
                    END IF;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        NULL; -- Ignora se a pré-inscrição foi apagada entretanto
                END;
            END LOOP;
        END;
        ```

---

## 6. Passo 5: Testar o Fluxo

1.  **Cenário 1 (Novo Cidadão):** Clique numa pré-inscrição com a tag "NOVO". Verifique se o formulário abre, os dados estão pré-preenchidos e o botão "Criar" está visível. Crie o inscrito e confirme que ele desaparece da lista.
2.  **Cenário 2 (Cidadão Existente):** Clique numa pré-inscrição com a tag "EXISTENTE". Verifique se o formulário abre, carrega os dados do cidadão já existente, mostra a notificação de aviso e o botão "Guardar" está visível.
3.  **Cenário 3 (Lote Misto):** Selecione várias pré-inscrições (novas e existentes). Clique em "Processar Selecionados em Lote". Verifique que apenas as novas são processadas e desaparecem da lista, enquanto as existentes permanecem para revisão manual.
