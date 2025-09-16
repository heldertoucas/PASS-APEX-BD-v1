DECLARE
    v_pre_insc PRE_INSCRICOES%ROWTYPE;
    v_inscrito_id INSCRITOS.ID_INSCRITO%TYPE;
BEGIN
    -- This process runs after the value of P10_ID_PRE_INSCRICAO has been set.
    -- If no ID was passed, do nothing.
    IF :P10_ID_PRE_INSCRICAO IS NULL THEN
        RETURN;
    END IF;

    -- Fetch the pre-inscription record.
    SELECT * INTO v_pre_insc
    FROM PRE_INSCRICOES
    WHERE ID_PRE_INSCRICAO = :P10_ID_PRE_INSCRICAO;

    -- Check for an existing citizen.
    BEGIN
        SELECT ID_INSCRITO INTO v_inscrito_id
        FROM INSCRITOS
        WHERE NIF = v_pre_insc.NIF OR Email = v_pre_insc.EMAIL;

        -- If found, set mode to UPDATE and set the Primary Key Item.
        -- The Form Initialization process will now use this PK to fetch the row.
        :P10_MODO := 'UPDATE';
        :P10_ID_INSCRITO := v_inscrito_id;

        apex_error.add_error(
            p_message          => 'Atenção: Já existe um inscrito com este NIF ou Email. Por favor, verifique e atualize os dados existentes.',
            p_display_location => apex_error.c_inline_in_notification
        );

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            -- If not found, set mode to CREATE and pre-fill the form items.
            :P10_MODO := 'CREATE';
            :P10_NOME_COMPLETO     := v_pre_insc.NOME_COMPLETO;
            :P10_EMAIL              := v_pre_insc.EMAIL;
            :P10_CONTACTO_TELEFONICO := v_pre_insc.CONTACTO_TELEFONICO;
            :P10_NIF                := v_pre_insc.NIF;
            :P10_DATA_NASCIMENTO    := v_pre_insc.DATA_NASCIMENTO;
    END;
END;
