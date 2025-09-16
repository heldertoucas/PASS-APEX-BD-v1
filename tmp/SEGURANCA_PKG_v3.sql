CREATE OR REPLACE PACKAGE BODY SEGURANCA_PKG AS

    FUNCTION is_role (p_role IN VARCHAR2) RETURN BOOLEAN AS
        v_funcao Utilizadores.Funcao%TYPE;
    BEGIN
        -- Bypass: Use the full, reliable package variable to check for a developer session.
        IF APEX_APPLICATION.G_BUILDER_SESSION_ID IS NOT NULL THEN
            RETURN TRUE;
        END IF;

        -- If not a developer, proceed with standard role check.
        IF v('APP_USER') IS NULL THEN
            RETURN FALSE;
        END IF;

        BEGIN
            SELECT Funcao INTO v_funcao
            FROM Utilizadores
            WHERE Email = v('APP_USER') AND Ativo = 'S';

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
