DECLARE
    v_pre_insc PRE_INSCRICOES%ROWTYPE;
    v_existing_count NUMBER;
BEGIN
    -- Check if any rows were selected in the Interactive Grid.
    -- The primary keys of selected rows are available in the G_F01 array.
    IF APEX_APPLICATION.G_F01.COUNT = 0 THEN
        RETURN; -- No rows selected, so do nothing.
    END IF;

    -- Loop through the array of selected pre-inscription IDs.
    FOR i IN 1..APEX_APPLICATION.G_F01.COUNT LOOP
    
        DECLARE
            l_pre_inscricao_id PRE_INSCRICOES.ID_PRE_INSCRICAO%TYPE := TO_NUMBER(APEX_APPLICATION.G_F01(i));
        BEGIN
            -- Get the full record for the current pre-inscription.
            SELECT * INTO v_pre_insc
            FROM PRE_INSCRICOES
            WHERE ID_PRE_INSCRICAO = l_pre_inscricao_id;

            -- Check if a corresponding citizen already exists.
            SELECT COUNT(*) INTO v_existing_count
            FROM INSCRITOS
            WHERE NIF = v_pre_insc.NIF OR Email = v_pre_insc.EMAIL;

            -- Only process if the citizen is NEW.
            IF v_existing_count = 0 THEN
            
                -- Create the new INSCRITOS record.
                INSERT INTO Inscritos (
                    Nome_Completo, Email, Contacto_Telefonico, NIF, Data_Nascimento,
                    Consentimento_RGPD, ID_Estado_Geral_Inscrito, Origem_Inscricao, Interesses_Iniciais
                ) VALUES (
                    v_pre_insc.Nome_Completo, v_pre_insc.Email, v_pre_insc.Contacto_Telefonico,
                    v_pre_insc.NIF, v_pre_insc.Data_Nascimento, v_pre_insc.Consentimento_Dados,
                    1, -- 'Ativo'
                    'Formulário Online (Processado em Lote)',
                    v_pre_insc.Interesses
                );

                -- Update the original PRE_INSCRICOES record to "Converted".
                UPDATE PRE_INSCRICOES
                SET ID_ESTADO_PRE_INSCRICAO = 3 -- 'Convertida em Inscrição'
                WHERE ID_PRE_INSCRICAO = l_pre_inscricao_id;
                
            END IF;
            -- If citizen exists, the loop does nothing for that row, leaving it for manual review.
            
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                -- This can happen if a row is deleted by another user after the page loads.
                -- We can ignore it and let the process continue to the next row.
                NULL; 
        END;

    END LOOP;
END;
