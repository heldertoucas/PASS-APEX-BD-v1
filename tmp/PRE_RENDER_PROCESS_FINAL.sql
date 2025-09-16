DECLARE
    v_pre_insc PRE_INSCRICOES%ROWTYPE;
    v_inscrito_id INSCRITOS.ID_INSCRITO%TYPE;
BEGIN
    -- Step 1: Fetch the pre-inscription record using the ID passed to the modal.
    SELECT * INTO v_pre_insc FROM PRE_INSCRICOES WHERE ID_PRE_INSCRICAO = :P10_ID_PRE_INSCRICAO;

    -- Step 2: Check if a citizen with the same NIF or Email already exists.
    BEGIN
        SELECT ID_INSCRITO INTO v_inscrito_id
        FROM INSCRITOS
        WHERE NIF = v_pre_insc.NIF OR Email = v_pre_insc.EMAIL;

        -- Step 3a: If found, set mode to UPDATE and set the Primary Key Item.
        -- The built-in Form Initialization process will now automatically fetch the record.
        :P10_MODO := 'UPDATE';
        :P10_ID_INSCRITO := v_inscrito_id; 

        -- Add a friendly warning message.
        apex_error.add_error(
            p_message          => 'Atenção: Já existe um inscrito com este NIF ou Email. Por favor, verifique e atualize os dados existentes.',
            p_display_location => apex_error.c_inline_in_notification
        );

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            -- Step 3b: If not found, set mode to CREATE and pre-fill the form items.
            :P10_MODO := 'CREATE';
            :P10_NOME_COMPLETO     := v_pre_insc.NOME_COMPLETO;
            :P10_EMAIL              := v_pre_insc.EMAIL;
            :P10_CONTACTO_TELEFONICO := v_pre_insc.CONTACTO_TELEFONICO;
            :P10_NIF                := v_pre_insc.NIF;
            :P10_DATA_NASCIMENTO    := v_pre_insc.DATA_NASCIMENTO;
    END;
END;
