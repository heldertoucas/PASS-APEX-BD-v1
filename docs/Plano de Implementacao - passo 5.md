### **Guia Detalhado e Consolidado: Passo 5 - O Funil de Entrada Inteligente**

**Objetivo:** Construir o fluxo de trabalho para o Técnico processar novas pré-inscrições, com validações automáticas para evitar a duplicação de cidadãos no sistema.

#### **5.1. Reconstruir a Página Principal (O "Caixote de Entrada" do Técnico)**

Para garantir uma base limpa e incorporar as melhorias de UX que planeámos, vamos (re)criar a página de relatório, assegurando que ela está otimizada desde o início.

1. **(Opcional) Apagar a Página Antiga:** Se já tem uma página "Novas Pré-Inscrições", a forma mais limpa de começar é apagá-la. No App Builder, encontre a página, clique no número e, no lado direito, em "Tasks", clique em **Delete**.
2. **Criar a Nova Página:**
   * No **App Builder**, clique em **Create Page**.
   * Selecione o tipo de página **Interactive Report**.
   * **Page Name:** `Novas Pré-Inscrições`
   * **Navigation > Create a navigation menu entry:** Ative esta opção.
3. **Definir a Fonte de Dados (SQL Query):**
   * Na página seguinte do assistente, escolha a opção **SQL Query**.
   * Na caixa de texto, cole o seguinte código. Ele já inclui a lógica para adicionar o texto `<i>(NOVO)</i>`:
       
     ```sql
     SELECT
         p.ID_PRE_INSCRICAO,
         CASE 
             WHEN APP_UTIL_PKG.is_pre_inscrito_novo(p.NIF, p.EMAIL) = 'S' 
             THEN p.NOME_COMPLETO || ' <i>(NOVO)</i>'
             ELSE p.NOME_COMPLETO 
         END AS NOME_COMPLETO,
         p.EMAIL,
         p.CONTACTO_TELEFONICO,
         p.NIF
     FROM
         PRE_INSCRICOES p
     WHERE
         p.ID_ESTADO_PRE_INSCRICAO = 1
     ```
     
4. Clique em **Create Page**.

#### **5.2. Configurar a Página de Relatório**

Agora vamos aplicar as configurações de segurança, navegação e formatação.

1. **Segurança da Página:**
   * No Page Designer, clique no nó principal da página à esquerda.
   * No painel direito, em **Security > Authorization Scheme**, selecione **is_tecnico**.
2. **Configurar o Link para o Formulário Modal:**
   * No painel da esquerda ("Rendering Tree"), clique em **Attributes** (por baixo da região do relatório).
   * No painel direito, na secção **Link**, clique no botão para editar o **Target**.
   * Na janela "Link Builder - Target":
     * **Target > Page:** Selecione a sua página modal **`22: Processar Pré-Inscrição`** (ou o número correto).
     * **Set Items > Name:** `P22_ID_PRE_INSCRICAO` (use o número da sua página modal).
     * **Set Items > Value:** Selecione a coluna `#ID_PRE_INSCRICAO#`.
   * Clique em **OK**.
3. **Permitir Formatação HTML na Coluna "Nome":**
   * No painel da esquerda, expanda a região do relatório e clique em **Columns**.
   * Clique na coluna **`NOME_COMPLETO`**.
   * No painel direito, desça até à secção **Security**.
   * **Desligue** o interruptor **`Escape special characters`**.
4. **Adicionar o Sumário e a Mensagem Dinâmica (Melhoria de UX):**
   * Crie um item de página escondido (`Hidden`) chamado `P22_TOTAL_NOVAS`.
   * Crie um processo **Pre-Rendering (Before Header)** para calcular o total de novas pré-inscrições e guardar em `P22_TOTAL_NOVAS`.
   * Crie uma região **PL/SQL Dynamic Content** no topo da página para mostrar a mensagem de estado (0, 1, ou mais pré-inscrições), formatada como um **Alert** e com o título da região escondido.
   * Adicione uma **Server-Side Condition** à região do relatório para que ela só seja mostrada se o valor em `P22_TOTAL_NOVAS` for diferente de `0`.
5. **"Resetar" o Relatório (Passo Obrigatório):**
   * Guarde todas as alterações.
   * Execute a página, clique em **Actions > Report > Reset**, e depois em **Apply**.
   * Para tornar a vista permanente, clique em **Actions > Report > Save Report > As Default Report Settings > Primary > Apply**.

#### **5.3. Criar a Página de Processamento (O "Formulário Inteligente")**

Esta página modal será o "cérebro" da operação.

1. Crie uma nova página do tipo **Form**.
2. **Page Name:** `Processar Pré-Inscrição`
3. **Page Mode:** Selecione **Modal Dialog**.
4. **Navigation:** Certifique-se de que a opção de criar entrada no menu está **DESATIVADA**.
5. **Data Source:** Selecione a tabela `INSCRITOS`.
6. **Ponto Crítico:** Após a criação, vá ao Page Designer e crie manualmente um item de página do tipo **Hidden** chamado **`P22_ID_PRE_INSCRICAO`** (use o número correto da sua página). Este passo é crucial e resolveu um dos nossos erros anteriores.

#### **5.4. Adicionar a "Inteligência": Lógica de Verificação e Pré-preenchimento**

Este processo é o coração da funcionalidade, agora atualizado com todas as correções que descobrimos.

1. **Criar o Processo de Pré-Rendering:**
   * Na página modal, no separador **Processing**, crie um processo em **Before Header**.
   * **Name:** `Verificar Existência e Pré-preencher`
   * **Type:** `Execute Code`
   * **PL/SQL Code:** Cole o seguinte código, que já está corrigido com os nomes de itens corretos (`P22_...`) e com a lógica para carregar os dados de inscritos existentes.
       
     ```sql
     DECLARE
         v_pre_insc PRE_INSCRICOES%ROWTYPE;
         v_inscrito_id INSCRITOS.ID_INSCRITO%TYPE;
     BEGIN
         -- 1. Obter os dados da pré-inscrição que foi clicada
         SELECT * INTO v_pre_insc FROM PRE_INSCRICOES WHERE ID_PRE_INSCRICAO = :P22_ID_PRE_INSCRICAO;
         -- 2. Tentar encontrar um inscrito com o mesmo NIF ou Email
         BEGIN
             SELECT ID_INSCRITO INTO v_inscrito_id
             FROM INSCRITOS
             WHERE NIF = v_pre_insc.NIF OR EMAIL = v_pre_insc.EMAIL;
             
             -- 3a. Se ENCONTROU, entramos em modo de ATUALIZAÇÃO
             :P22_MODO := 'UPDATE';
             :P22_ID_INSCRITO := v_inscrito_id;
             
             -- Carregar TODOS os dados do inscrito existente para os itens da página
             SELECT
                 NOME_COMPLETO, EMAIL, CONTACTO_TELEFONICO, NIF, DATA_NASCIMENTO,
                 ID_GENERO, NATURALIDADE, NACIONALIDADE, ID_TIPO_DOC_IDENTIFICACAO,
                 DOC_IDENTIFICACAO_NUM, VALIDADE_DOC_IDENTIFICACAO, MORADA, CODIGO_POSTAL,
                 LOCALIDADE_CODIGO_POSTAL, ID_SITUACAO_PROFISSIONAL, ID_QUALIFICACAO,
                 CONSENTIMENTO_RGPD, ID_ESTADO_GERAL_INSCRITO, INTERESSES_INICIAIS,
                 ORIGEM_INSCRICAO, OBSERVACOES
             INTO
                 :P22_NOME_COMPLETO, :P22_EMAIL, :P22_CONTACTO_TELEFONICO, :P22_NIF, :P22_DATA_NASCIMENTO,
                 :P22_ID_GENERO, :P22_NATURALIDADE, :P22_NACIONALIDADE, :P22_ID_TIPO_DOC_IDENTIFICACAO,
                 :P22_DOC_IDENTIFICACAO_NUM, :P22_VALIDADE_DOC_IDENTIFICACAO, :P22_MORADA, :P22_CODIGO_POSTAL,
                 :P22_LOCALIDADE_CODIGO_POSTAL, :P22_ID_SITUACAO_PROFISSIONAL, :P22_ID_QUALIFICACAO,
                 :P22_CONSENTIMENTO_RGPD, :P22_ID_ESTADO_GERAL_INSCRITO, :P22_INTERESSES_INICIAIS,
                 :P22_ORIGEM_INSCRICAO, :P22_OBSERVACOES
             FROM INSCRITOS
             WHERE ID_INSCRITO = v_inscrito_id;
             -- Adiciona uma mensagem de aviso amigável
             apex_error.add_error(
                 p_message          => 'Atenção: Já existe um inscrito com este NIF ou Email. Por favor, verifique e atualize os dados existentes.',
                 p_display_location => apex_error.c_inline_in_notification
             );
         EXCEPTION
             WHEN NO_DATA_FOUND THEN
                 -- 3b. Se NÃO ENCONTROU, entramos em modo de CRIAÇÃO
                 :P22_MODO := 'CREATE';
                 
                 -- Pré-preenchemos os campos essenciais do formulário
                 :P22_NOME_COMPLETO     := v_pre_insc.NOME_COMPLETO;
                 :P22_EMAIL              := v_pre_insc.EMAIL;
                 :P22_CONTACTO_TELEFONICO := v_pre_insc.CONTACTO_TELEFONICO;
                 :P22_NIF                := v_pre_insc.NIF;
                 :P22_DATA_NASCIMENTO    := v_pre_insc.DATA_NASCIMENTO;
         END;
     END;
     ```

#### **5.5. Configurar a Interface: Botões Condicionais e Processo Final**

1. **Botões Condicionais:**
   * No Page Designer da página modal, crie o item escondido `P22_MODO`.
   * Configure a **Server-Side Condition** do botão `CREATE` para `Item = Value`, Item: `P22_MODO`, Value: `CREATE`.
   * Configure a **Server-Side Condition** do botão `SAVE` para `Item = Value`, Item: `P22_MODO`, Value: `UPDATE`.
2. **Processo Final de Atualização:**
   * No separador **Processing**, crie um novo processo **depois** do processo "Form - Automatic Row Processing".
   * **Name:** `Atualizar Estado da Pré-Inscrição`
   * **Type:** `Execute Code`
   * **PL/SQL Code:**
       
     ```sql
     UPDATE PRE_INSCRICOES
        SET ID_ESTADO_PRE_INSCRICAO = 3 -- ID para "Convertida"
      WHERE ID_PRE_INSCRICAO = :P22_ID_PRE_INSCRICAO;
     ```
       
   * **Server-Side Condition:** Configure a condição para ser do tipo **`Request is contained in Value List`** com o **Value:** `CREATE,SAVE`.

#### **5.6. Testar o Fluxo Inteligente Completo**

(O procedimento de teste permanece o mesmo do guião anterior, agora com a confiança de que a implementação está robusta).

---

### **5.7. Otimização: Processamento de Pré-inscrições em Série (Batch)**

Depois de implementar o fluxo para uma única pré-inscrição, o próximo passo lógico é otimizar o trabalho do Técnico, permitindo-lhe validar e converter múltiplas pré-inscrições "novas" de uma só vez.

**Análise Crítica do Plano Proposto**

*   **Ponto Forte:** O plano utilizava corretamente as funcionalidades modernas do APEX para a interface (Row Selection) e tentava usar uma abordagem baseada em conjuntos (`INSERT...SELECT`), o que é bom em termos de intenção.
*   **Erro Crítico na Lógica (Violação da Regra de Negócio):**
    *   **O Problema:** A falha estava no passo de `UPDATE`. O código proposto iria fazer o seguinte:
        1.  Inserir com sucesso apenas as pré-inscrições **novas**.
        2.  De seguida, iria atualizar o estado de **todas** as pré-inscrições selecionadas (tanto as novas como as duplicadas) que tivessem uma correspondência na tabela `Inscritos`.
    *   **A Consequência:** Isto significa que as pré-inscrições de cidadãos **duplicados**, que queríamos deixar na lista para revisão manual, seriam incorretamente marcadas como "Convertidas" e desapareceriam da lista do Técnico, sem que os seus dados fossem atualizados ou a sua nova intenção (ex: interesse num novo curso) fosse registada. Isto representa uma perda de informação e uma falha na lógica de negócio.
*   **Ineficiência Subtil:** A abordagem de usar `MEMBER OF` com uma coleção de `VARCHAR2` para consultar uma coluna `NUMBER` funciona, mas depende de conversões de tipo de dados implícitas, o que não é a prática mais robusta nem a mais eficiente.

---

### **Plano de Ação Revisto e Melhorado**

O plano revisto utiliza uma abordagem PL/SQL mais explícita e profissional que é, ao mesmo tempo, mais eficiente e, mais importante, **logicamente correta**. Este método garante que apenas as pré-inscrições que são verdadeiramente novas são processadas e atualizadas.

#### **Parte A: Preparar a Interface do Utilizador**

Esta parte do plano original estava correta e mantém-se:

1.  **Ativar a Seleção de Linhas (Checkboxes):** Na página "Novas Pré-Inscrições", clique na região do **Interactive Report**, vá a **Attributes** e ative **Row Selection**.
2.  **Adicionar o Botão de Ação:** Crie um botão na região do relatório com o nome `VALIDAR_SELECIONADOS` e a ação `Submit Page`.

#### **Parte B: Implementar a Lógica de Processamento (Versão Corrigida)**

Esta é a parte que foi completamente reescrita para garantir a correção e eficiência.

1.  **Criar o Processo "After Submit":**
    *   Vá ao separador **Processing**.
    *   Crie um novo processo chamado `Processar Pré-inscrições em Série`.
    *   **Server-Side Condition > When Button Pressed:** Selecione o seu botão `VALIDAR_SELECIONADOS`.
    *   **Source > Type:** `Execute Code`.
    *   **Source > PL/SQL Code:** Substitua qualquer código anterior por este bloco revisto:
    ```sql
    DECLARE
        -- Variável para guardar os dados de uma pré-inscrição
        v_pre_insc PRE_INSCRICOES%ROWTYPE;
        -- Variável para contar se já existe um inscrito com o mesmo NIF ou Email
        v_existing_count NUMBER;
    BEGIN
        -- Se nenhum registo foi selecionado, não faz nada.
        IF apex_application.g_f01.COUNT = 0 THEN
            RETURN;
        END IF;
    
        -- Itera sobre todos os IDs das pré-inscrições que foram selecionadas (checkboxes)
        FOR i IN 1..apex_application.g_f01.COUNT LOOP
        
            -- Bloco anónimo para isolar o tratamento de cada pré-inscrição
            DECLARE
                l_pre_inscricao_id PRE_INSCRICOES.ID_PRE_INSCRICAO%TYPE := TO_NUMBER(apex_application.g_f01(i));
            BEGIN
                -- 1. Obtém o registo completo da pré-inscrição atual
                SELECT *
                INTO v_pre_insc
                FROM PRE_INSCRICOES
                WHERE ID_PRE_INSCRICAO = l_pre_inscricao_id;
    
                -- 2. Verifica se já existe um cidadão na tabela principal com o mesmo NIF ou Email
                SELECT COUNT(*)
                INTO v_existing_count
                FROM INSCRITOS
                WHERE NIF = v_pre_insc.NIF OR Email = v_pre_insc.EMAIL;
    
                -- 3. Apenas processa se for um cidadão NOVO (não encontrado na tabela INSCRITOS)
                IF v_existing_count = 0 THEN
                
                    -- 3a. Cria o novo registo na tabela INSCRITOS com os dados base
                    INSERT INTO Inscritos (
                        Nome_Completo,
                        Email,
                        Contacto_Telefonico,
                        NIF,
                        Data_Nascimento,
                        Consentimento_RGPD,
                        ID_Estado_Geral_Inscrito,
                        Origem_Inscricao,
                        Interesses_Iniciais
                    ) VALUES (
                        v_pre_insc.Nome_Completo,
                        v_pre_insc.Email,
                        v_pre_insc.Contacto_Telefonico,
                        v_pre_insc.NIF,
                        v_pre_insc.Data_Nascimento,
                        v_pre_insc.Consentimento_Dados, -- Mapeamento direto do consentimento
                        1, -- ID para 'Ativo'
                        'Formulário Online (Processado em Série)', -- Identifica a origem da criação
                        v_pre_insc.Interesses
                    );
    
                    -- 3b. Atualiza o estado da pré-inscrição para 'Convertida'
                    -- O ID para 'Convertida em Inscrição' é 3
                    UPDATE PRE_INSCRICOES
                    SET ID_ESTADO_PRE_INSCRICAO = 3
                    WHERE ID_PRE_INSCRICAO = l_pre_inscricao_id;
                    
                END IF;
                -- Se v_existing_count > 0, o código não faz nada, deixando a pré-inscrição
                -- na lista para ser processada manualmente pelo Técnico, como pretendido.
                
            EXCEPTION
                -- No caso improvável de um ID selecionado não ser encontrado,
                -- regista um aviso e continua para o próximo, sem parar o processo.
                WHEN NO_DATA_FOUND THEN
                    apex_debug.warn('Pré-inscrição com ID ' || l_pre_inscricao_id || ' não encontrada durante o processamento em série.');
            END;
    
        END LOOP;
    END;
    ```

2.  **Guardar as alterações.**