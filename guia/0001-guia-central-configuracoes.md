# Guia de Implementação Definitivo: Central de Configurações

**Versão:** 1.0
**Autor:** Gemini
**Propósito:** Este documento fornece um guia passo a passo consolidado para recriar a "Central de Configurações", a interface de gestão para o perfil de Coordenador, com base nas melhores práticas identificadas na documentação do projeto e na documentação oficial do Oracle APEX.

---

## 1. Objetivo e Arquitetura

O objetivo é construir uma interface de gestão centralizada, segura e robusta que permita ao **Coordenador** gerir todas as tabelas de catálogo e de lookup do sistema.

Para evitar um menu de navegação sobrecarregado, utilizamos a arquitetura **"Hub & Spoke"**:

*   **Página Hub:** Uma única página no menu de navegação chamada `Central de Configurações`. Funciona como um painel de controlo a partir do qual o Coordenador seleciona a tabela que deseja gerir.
*   **Páginas Spoke:** Várias páginas de gestão de dados (uma para cada tabela), que não têm entrada no menu. O acesso a estas páginas é feito exclusivamente através da página Hub.

---

## 2. Passo 1: Criação da Página "Hub"

Esta página servirá como o ponto de entrada para toda a gestão de catálogos.

1.  **Criar a Página em Branco:**
    *   No APEX App Builder, clique em **Create Page**.
    *   Selecione o tipo de página **Blank Page**.
    *   **Name:** `Central de Configurações`.
    *   **Navigation:** Ative a opção **Create a navigation menu entry**.
    *   Clique em **Create Page**.

2.  **Configurar Propriedades e Segurança:**
    *   No Page Designer, com a nova página selecionada, vá ao painel de propriedades à direita.
    *   **Alias:** Defina um alias estático e amigável, como `CENTRAL_CONFIG`.
    *   **Security > Authorization Scheme:** Selecione o esquema de autorização `is_coordenador`. Isto garante que apenas os coordenadores podem ver e aceder a esta página.

3.  **Criar o Seletor de Navegação:**
    *   No painel de "Rendering" (à esquerda), crie uma nova região do tipo **Static Content**. Dê-lhe o nome `Opções de Gestão`.
    *   Arraste um item do tipo **Select List** para dentro desta região.
    *   Configure as propriedades do item Select List:
        *   **Name:** `P<ID_DA_PAGINA>_PAGINA_ALVO` (ex: `P2_PAGINA_ALVO`).
        *   **Label:** `Selecione uma Tabela para Gerir`.
        *   **List of Values > Type:** `Static Values`.
        *   **List of Values > Static Values:** Clique para editar e adicione as tabelas que o Coordenador irá gerir. Use o nome amigável como "Display Value" e o **Alias** da futura página "Spoke" como "Return Value". Comece com uma entrada:
            *   **Display Value:** `Gerir Cursos`
            *   **Return Value:** `GESTAO_CURSOS` (Fiquei aqui: a colocar todas as tabelas que devem ser alteradas.)
        *   **Advanced > Page Action on Selection:** Selecione `Submit Page`.

4.  Clique em **Save**.

---

## 3. Passo 2: Criação de uma Página "Spoke" Modelo (Gestão de Cursos)

Vamos criar a primeira página de gestão para a tabela `CURSOS`. Esta servirá de modelo para todas as outras.

1.  **Criar a Página Interactive Grid:**
    *   No App Builder, clique em **Create Page**.
    *   Selecione o tipo de página **Interactive Grid**.
    *   **Page Name:** `Gestão de Cursos`.
    *   **Navigation:** **DESATIVE** a opção `Create a navigation menu entry`.
    *   **Data Source:** Selecione a tabela `CURSOS`.
    *   Clique em **Create Page**.

2.  **Configurar Propriedades e Segurança da Spoke:**
    *   No Page Designer da nova página, defina o **Alias** como `GESTAO_CURSOS`.
    *   Em **Security > Authorization Scheme**, selecione `is_coordenador`.

3.  **Garantir que a Grelha é Editável (Checklist Essencial):**
    *   No painel "Rendering" (à esquerda), clique no nó **"Attributes"** da sua região Interactive Grid. No painel de propriedades, na secção **"Edit"**, certifique-se de que o interruptor **"Enabled"** está **LIGADO**.
    *   Clique no nome da **região** Interactive Grid. No painel de propriedades, na secção **"Source"**, verifique se o campo **"Primary Key Column"** está corretamente preenchido com `ID_CURSO`.

4.  **Melhorar a Usabilidade com Popup LOVs:**
    *   A tabela `CURSOS` tem colunas de chave estrangeira como `ID_PROGRAMA` e `ID_ESTADO_CURSO`. Vamos transformá-las em seletores amigáveis.
    *   **Crie os LOVs:** Primeiro, vá a **Shared Components > List of Values** e crie os LOVs dinâmicos necessários.
        *   **Nome:** `LOV_PROGRAMAS`
        *   **SQL Query:** `SELECT NOME d, ID_PROGRAMA r FROM PROGRAMAS ORDER BY NOME`
        *   **Nome:** `LOV_ESTADOS_CURSO`
        *   **SQL Query:** `SELECT NOME d, ID_ESTADO_CURSO r FROM TIPOS_ESTADO_CURSO ORDER BY ORDEM_EXIBICAO`
    *   **Configure as Colunas:** Volte ao Page Designer da sua página `GESTAO_CURSOS`.
        *   Selecione a coluna `ID_PROGRAMA`.
        *   Altere o seu **Type** para **Popup LOV**.
        *   Na secção **List of Values**, defina o **Type** como `Shared Component` e selecione o `LOV_PROGRAMAS` que acabou de criar.
        *   Repita o processo para a coluna `ID_ESTADO_CURSO`, usando o `LOV_ESTADOS_CURSO`.

5.  Clique em **Save**.

---

## 4. Passo 3: Implementação da Navegação Dinâmica

Agora, vamos ligar o "Hub" ao "Spoke".

1.  Navegue para a página "Hub" (`CENTRAL_CONFIG`) no Page Designer.
2.  Vá para o separador **Processing**.
3.  Crie um novo **Branch** no evento **After Submit**.
4.  Configure o Branch:
    *   **Name:** `Redirecionar para Página de Gestão`.
    *   **Behavior > Type:** `Page or URL (Redirect)`.
    *   **Behavior > Target:** Clique para abrir o "Link Builder".
        *   **Page:** `&P2_PAGINA_ALVO.` (Substitua P2 pelo ID da sua página Hub).
        *   **Clear Cache:** `&P2_PAGINA_ALVO.` (Este passo é crucial para evitar erros de "Session State Protection").
        *   Clique em **OK**.
5.  Clique em **Save**.

---

## 5. Passo 4: Expansão e Testes

1.  **Expandir:**
    *   Repita os passos da secção 3 ("Criação de uma Página Spoke Modelo") para todas as outras tabelas de catálogo e de lookup que o Coordenador precisa de gerir. A lista inclui:
        *   `Utilizadores`
        *   `Programas`
        *   `Competencias`
        *   `Modelos_De_Comunicacao`
        *   `Configuracoes_Formulario`
        *   Todas as tabelas `Tipos_*` (ex: `Tipos_Estado_Turma`, `Tipos_Genero`, etc.)
    *   Para cada nova página "Spoke" que criar, lembre-se de:
        1.  Definir um **Alias** único.
        2.  Aplicar a segurança `is_coordenador`.
        3.  Garantir que a grelha é editável.
        4.  Adicionar uma nova entrada na lista de seleção da página "Hub" com o Alias correspondente.

2.  **Testar:**
    *   Faça login na aplicação com o utilizador `COORD_TESTE`.
    *   Navegue para a "Central de Configurações". O menu deve estar visível.
    *   Selecione "Gerir Cursos" na lista. Deve ser redirecionado para a página de gestão de cursos.
    *   Tente editar um campo (clique duas vezes numa célula). Deverá conseguir alterar o valor e guardar.
    *   Faça logout e login com o utilizador `TECNICO_TESTE`.
    *   Confirme que o menu "Central de Configurações" **não está visível**.
