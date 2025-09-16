CREATE OR REPLACE PACKAGE BODY SEGURANCA_PKG AS

    FUNCTION is_role (p_role IN VARCHAR2) RETURN BOOLEAN AS
        v_funcao Utilizadores.Funcao%TYPE;
    BEGIN
        -- If the user is not logged in, they have no role.
        IF v('APP_USER') IS NULL THEN
            RETURN FALSE;
        END IF;

        -- Standard role check against the Utilizadores table.
        BEGIN
            SELECT Funcao INTO v_funcao
            FROM Utilizadores
            WHERE Email = v('APP_USER') AND Ativo = 'S';

            -- Check if the user has the required role.
            -- A Coordenador has access to everything.
            IF v_funcao = 'COORDENADOR' THEN
                RETURN TRUE;
            ELSIF v_funcao = p_role THEN
                RETURN TRUE;
            ELSE
                RETURN FALSE;
            END IF;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- If the user is not in our table, they have no access.
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
