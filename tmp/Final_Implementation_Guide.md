# Final Implementation Guide: Pre-inscriptions Funnel

This document provides a complete and corrected summary of the steps required to implement the Pre-inscriptions Funnel feature in your APEX application.

## 1. Summary of Issues Resolved

We encountered and solved three distinct issues:

1.  **Access Denied for Admin:** The `is_tecnico` authorization scheme was correctly blocking your admin user. We fixed this by creating a data-driven solution, adding your admin user to the `UTILIZADORES` table with the 'COORDENADOR' role and simplifying the security package to recognize this.
2.  **Modal Form Not Populating:** The `ORA-01403: no data found` error occurred because the `Before Header` process was firing before the page item with the Pre-Inscription ID was set in the session. We are fixing this by using the correct APEX process type: **Form - Initialization**.
3.  **Batch Processing Not Working:** The initial process type (`Interactive Grid - DML`) was incorrect for a custom batch action. We are fixing this by using a standard `PL/SQL Code` process that correctly loops through the selected rows.

---

## 2. Step-by-Step Implementation Guide

Please follow these steps carefully to ensure all components are configured correctly.

### **Step A: Configure Security (`SEGURANCA_PKG`)**

**Goal:** Ensure your admin user can access the pages and that the security logic is clean.

1.  **Add Your Admin User to the Data:**
    *   Go to **SQL Workshop > SQL Commands**.
    *   Run this script to add your user to the application's user table. This is the definitive solution to the access problem.
    ```sql
    BEGIN
        -- First, try to delete the user to make the script re-runnable
        DELETE FROM UTILIZADORES WHERE Email = 'HELDERTOUCAS@GMAIL.COM';
        -- Insert the admin user with the COORDENADOR role
        INSERT INTO UTILIZADORES (Nome_Completo, Email, Funcao, Ativo)
        VALUES ('Admin User', 'HELDERTOUCAS@GMAIL.COM', 'COORDENADOR', 'S');
        COMMIT;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            -- This will happen if the user doesn't exist, which is fine.
            INSERT INTO UTILIZADORES (Nome_Completo, Email, Funcao, Ativo)
            VALUES ('Admin User', 'HELDERTOUCAS@GMAIL.COM', 'COORDENADOR', 'S');
            COMMIT;
    END;
    /
    ```

2.  **Update the Security Package Body:**
    *   Go to **SQL Workshop > Object Browser**.
    *   Select **Packages > SEGURANCA_PKG**.
    *   Click the **Body** tab.
    *   Delete all existing code and replace it with the following simplified code:
    ```sql
    CREATE OR REPLACE PACKAGE BODY SEGURANCA_PKG AS

        FUNCTION is_role (p_role IN VARCHAR2) RETURN BOOLEAN AS
            v_funcao Utilizadores.Funcao%TYPE;
        BEGIN
            -- If the user is not logged in, they have no role.
            IF v('APP_USER') IS NULL THEN
                RETURN FALSE;
            END IF;

            BEGIN
                SELECT Funcao INTO v_funcao
                FROM Utilizadores
                WHERE Email = v('APP_USER') AND Ativo = 'S';

                -- A Coordenador can do anything a Tecnico can.
                IF v_funcao = 'COORDENADOR' THEN
                    RETURN TRUE;
                END IF;
                
                -- Check for the specific role.
                IF v_funcao = p_role THEN
                    RETURN TRUE;
                ELSE
                    RETURN FALSE;
                END IF;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    RETURN FALSE;
            END;
        END is_role;

        FUNCTION is_coordenador RETURN BOOLEAN AS
        BEGIN
            RETURN is_role('COORDENADOR');
        END is_coordenador;

        FUNCTION is_tecnico RETURN BOOLEAN AS
        BEGIN
            RETURN is_role('TECNICO');
        END is_tecnico;

        FUNCTION is_formador RETURN BOOLEAN AS
        BEGIN
            RETURN is_role('FORMADOR');
        END is_formador;

        FUNCTION get_user_role (p_email IN VARCHAR2) RETURN VARCHAR2 AS
            v_funcao Utilizadores.Funcao%TYPE;
        BEGIN
            SELECT Funcao INTO v_funcao
            FROM Utilizadores
            WHERE Email = p_email AND Ativo = 'S';
            RETURN v_funcao;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                RETURN NULL;
        END get_user_role;

    END SEGURANCA_PKG;
    /
    ```
    *   Click **Save and Compile**.

### **Step B: Configure the Modal Form Page (`Processar Pré-Inscrição`)**

**Goal:** Fix the `no data found` error and ensure the form closes correctly.

1.  **Delete Old Process:**
    *   Navigate to the Page Designer for your modal page.
    *   Go to the **Processing** tab.
    *   Right-click the `Definir Modo e Chave Primária` process and **Delete** it.

2.  **Create Correct Initialization Process:**
    *   In the **Pre-Rendering** section, right-click on the **`Form - Initialization`** process (it should already exist) and ensure its settings are correct, or create it if it's missing.
    *   **Identification > Name**: `Form - Initialization`
    *   **Type**: `Form - Initialization`
    *   **Settings > Table Name**: `INSCRITOS`
    *   **Settings > Primary Key Item**: Select your hidden item for the `INSCRITOS` PK (e.g., `P10_ID_INSCRITO`).

3.  **Add Custom Logic to the Initialization Process:**
    *   Select the `Form - Initialization` process.
    *   Scroll down to the **Source** section.
    *   In the **PL/SQL Code** box, paste the following code. This code runs *within* the initialization process and correctly handles the logic.
    ```sql
    DECLARE
        v_pre_insc PRE_INSCRICOES%ROWTYPE;
        v_inscrito_id INSCRITOS.ID_INSCRITO%TYPE;
    BEGIN
        IF :P10_ID_PRE_INSCRICAO IS NOT NULL THEN
            SELECT * INTO v_pre_insc FROM PRE_INSCRICOES WHERE ID_PRE_INSCRICAO = :P10_ID_PRE_INSCRICAO;

            BEGIN
                SELECT ID_INSCRITO INTO v_inscrito_id
                FROM INSCRITOS
                WHERE NIF = v_pre_insc.NIF OR Email = v_pre_insc.EMAIL;

                :P10_MODO := 'UPDATE';
                :P10_ID_INSCRITO := v_inscrito_id;

                apex_error.add_error(
                    p_message          => 'Atenção: Já existe um inscrito com este NIF ou Email. Por favor, verifique e atualize os dados existentes.',
                    p_display_location => apex_error.c_inline_in_notification
                );

            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    :P10_MODO := 'CREATE';
                    :P10_NOME_COMPLETO     := v_pre_insc.NOME_COMPLETO;
                    :P10_EMAIL              := v_pre_insc.EMAIL;
                    :P10_CONTACTO_TELEFONICO := v_pre_insc.CONTACTO_TELEFONICO;
                    :P10_NIF                := v_pre_insc.NIF;
                    :P10_DATA_NASCIMENTO    := v_pre_insc.DATA_NASCIMENTO;
            END;
        END IF;
    END;
    ```
    *Remember to replace all `P10_` prefixes with your modal page's actual number.* 

4.  **Create the `Close Dialog` Process:**
    *   Go to the **Processing** tab.
    *   Right-click on the **After Submit** event and select **Create Process**.
    *   **Name**: `Fechar Janela`
    *   **Type**: `Close Dialog`
    *   **Server-Side Condition > Type**: `Request is contained in Value List`
    *   **Server-Side Condition > Value**: `CREATE_BUTTON,UPDATE_BUTTON`
    *   Drag this process to be the **last** process in the sequence.

### **Step C: Configure the Main Grid Page (`Novas Pré-Inscrições`)**

**Goal:** Fix the batch processing.

1.  **Delete Old Process:**
    *   Navigate to the Page Designer for the Interactive Grid page.
    *   Go to the **Processing** tab.
    *   Right-click the `Processar Lote de Pré-Inscrições` process and **Delete** it.

2.  **Create Correct Batch Process:**
    *   Right-click on the **Processing** event and select **Create Process**.
    *   **Name**: `Processar Lote`
    *   **Type**: `PL/SQL Code`
    *   **PL/SQL Code**: Paste the following code:
    ```sql
    DECLARE
        v_pre_insc PRE_INSCRICOES%ROWTYPE;
        v_existing_count NUMBER;
    BEGIN
        IF APEX_APPLICATION.G_F01.COUNT = 0 THEN
            RETURN;
        END IF;

        FOR i IN 1..APEX_APPLICATION.G_F01.COUNT LOOP
            DECLARE
                l_pre_inscricao_id PRE_INSCRICOES.ID_PRE_INSCRICAO%TYPE := TO_NUMBER(APEX_APPLICATION.G_F01(i));
            BEGIN
                SELECT * INTO v_pre_insc FROM PRE_INSCRICOES WHERE ID_PRE_INSCRICAO = l_pre_inscricao_id;

                SELECT COUNT(*) INTO v_existing_count FROM INSCRITOS WHERE NIF = v_pre_insc.NIF OR Email = v_pre_insc.EMAIL;

                IF v_existing_count = 0 THEN
                    INSERT INTO Inscritos (Nome_Completo, Email, Contacto_Telefonico, NIF, Data_Nascimento, Consentimento_RGPD, ID_Estado_Geral_Inscrito, Origem_Inscricao, Interesses_Iniciais)
                    VALUES (v_pre_insc.Nome_Completo, v_pre_insc.Email, v_pre_insc.Contacto_Telefonico, v_pre_insc.NIF, v_pre_insc.Data_Nascimento, v_pre_insc.Consentimento_Dados, 1, 'Formulário Online (Lote)', v_pre_insc.Interesses);

                    UPDATE PRE_INSCRICOES SET ID_ESTADO_PRE_INSCRICAO = 3 WHERE ID_PRE_INSCRICAO = l_pre_inscricao_id;
                END IF;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    NULL;
            END;
        END LOOP;
    END;
    ```
    *   **Server-Side Condition > When Button Pressed**: Select your `PROCESSAR_LOTE` button.

