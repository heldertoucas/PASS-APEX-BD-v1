### **Guia Integral e Definitivo (Versão 4.0 \- Consolidada): Passo 4 \- A Sala de Controlo do Coordenador**

**Objetivo:** Construir uma interface de gestão centralizada, segura, robusta e editável para o Coordenador, permitindo-lhe gerir todas as tabelas de base do sistema (como a lista de cursos, competências, etc.).

**Estratégia: A Arquitetura "Hub & Spoke" Melhorada**

Para manter a aplicação limpa e organizada, usaremos um padrão de design profissional chamado "Hub & Spoke" (Centro e Raios).

* **O "Hub" (O Centro):** Será uma única página no menu chamada "Central de Configurações". Funcionará como um menu principal para todas as tarefas de gestão.  
* **Os "Spokes" (Os Raios):** Serão as várias páginas de gestão individuais (uma para Cursos, uma para Competências, etc.). Estas páginas não aparecerão no menu principal; o acesso será feito exclusivamente através do nosso "Hub".

Esta abordagem evita um menu de navegação com dezenas de links, tornando a experiência do utilizador muito mais agradável.

---

#### **4.1. Criar a Página "Hub" (O Centro da Roda)**

(Esta secção permanece inalterada, pois a sua implementação foi direta e sem problemas.)

1. Na página inicial do seu Workspace, clique em **App Builder** e depois no botão **Create**.  
2. Selecione **New Application**.  
3. Dê um nome à aplicação, por exemplo: `Passaporte Competências Digitais`.  
4. Clique no botão **Create Application**. O APEX irá criar uma aplicação básica com uma página inicial (Home) e uma página de Login.  
5. Será levado para o "App Builder" da sua nova aplicação. Clique no botão **Create Page**.  
6. Selecione o tipo de página **Blank Page** e clique em **Next**.  
7. Preencha os seguintes campos:  
   * **Name:** `Central de Configurações`.  
   * Na secção **Navigation**, ative a opção **Create a navigation menu entry**.  
8. Clique em **Next** e depois em **Create Page**.  
9. Será levado para o "Page Designer". Com a página selecionada à esquerda (ex: `Page 2: Central de Configurações`), vá ao painel de propriedades à direita:  
   * **Alias:** Escreva `CENTRAL_CONFIG`. (Pense no Alias como uma "morada" permanente e amigável para a sua página. É muito mais robusto do que usar o número da página, que pode mudar).  
   * **Security \> Authorization Scheme:** Selecione o esquema que criámos no Passo 3, **is\_coordenador**.  
10. Clique em **Save** no canto superior direito.

**Resultado:** Acabámos de criar a nossa página "Hub", que só será visível para utilizadores com o perfil de Coordenador.

#### **4.2. Criar a Primeira Página "Spoke" (Gestão de Cursos)**

Agora, vamos criar a nossa primeira página de gestão. Usaremos o componente **Interactive Grid**.

1. Volte ao dashboard da sua aplicação.  
2. Clique novamente em **Create Page**.  
3. Selecione o tipo de página **Interactive Grid**.  
4. Preencha o formulário:  
   * **Page Name:** `Gestão de Cursos`.  
   * Na secção **Navigation**, **DESATIVE** a opção **Create a navigation menu entry**. Isto é crucial para a nossa arquitetura.  
5. Clique em **Next**.  
6. Em **Data Source**, selecione a tabela `CURSOS` e clique em **Next**.  
7. Clique em **Create Page**.  
8. No Page Designer da página recém-criada, vá às suas propriedades no painel direito:  
   * **Alias:** Escreva `GESTAO_CURSOS`.  
   * **Security \> Authorization Scheme:** Selecione **is\_coordenador**.  
9. Clique em **Save**.

**Resultado:** Temos uma página "Spoke" funcional e segura, mas ainda inacessível e, por omissão, provavelmente não editável. Vamos corrigir isso.

---

##### **4.2.1. Garantir que a Grelha é Editável (Passo Essencial)**

Após criar uma grelha interativa, é uma boa prática verificar sempre duas configurações que garantem a sua funcionalidade de edição.

1. **Ativar a Edição (O "Interruptor Principal"):**  
     
   * No Page Designer da página `Gestão de Cursos`, no painel da esquerda ("Rendering Tree"), clique na opção **"Attributes"** que aparece abaixo da sua região "Interactive Grid".  
   * No painel de propriedades à direita, na primeira secção **"Edit"**, confirme que o interruptor **"Enabled"** está **LIGADO**. Se não estiver, esta é a razão pela qual não consegue editar.

   

2. **Definir a Chave Primária (O "Cartão de Cidadão" da Linha):**  
     
   * No painel da esquerda, clique agora no nome da **região** (não nos "Attributes").  
   * No painel de propriedades à direita, desça até à secção **Source**.  
   * No campo **"Primary Key Column"**, certifique-se de que a coluna correta está selecionada (para a tabela `CURSOS`, deve ser `ID_CURSO`). Se este campo estiver em branco, o APEX não sabe qual a linha a atualizar e desativa a edição.

   

3. Clique em **Save**.

---

#### **4.3. Implementar a Lógica de Navegação Melhorada**

Agora vamos ligar o "Hub" ao "Spoke" com a configuração robusta que descobrimos ser necessária.

1. **Configurar o Seletor no Hub:**  
     
   * Navegue para a página "Hub" (`CENTRAL_CONFIG`) no Page Designer.  
   * Crie uma nova região chamada `Opções de Gestão`.  
   * Arraste um item **Select List** para dentro dessa região.  
   * Configure as suas propriedades:  
     * **Name:** `P2_PAGINA_ALVO`  
     * **Label:** `Selecione uma Opção de Gestão`  
     * **List of Values \> Type:** `Static Values`  
     * Edite os **Static Values** para:  
       * Display Value: `Gerir Cursos`  
       * Return Value: `GESTAO_CURSOS` (O Alias que definimos\!)  
     * **Advanced \> Page Action on Selection:** `Submit Page`.

   

2. **Criar o Ramo de Redirecionamento (Branch) Corrigido:**  
     
   * No separador **Processing** (à esquerda), crie um novo **Branch** (em "After Submit").  
   * Configure o ramo:  
     * **Name:** `Redirecionar para Página de Gestão`  
     * **Behavior \> Type:** `Page or URL (Redirect)`  
     * **Behavior \> Target:** Clique neste campo para abrir a janela **"Link Builder \- Target"**.  
       * Dentro da janela "Link Builder":  
         * **Page:** `&P2_PAGINA_ALVO.`  
         * **Clear Cache:** `&P2_PAGINA_ALVO.`  
       * Clique em **OK**.

   

   **Ponto de Atenção \- Porquê Limpar a Cache?** O erro que investigámos de ser redirecionado para a página de login é um problema comum no APEX, geralmente causado pela "Proteção de Estado da Sessão" (Session State Protection). Ao adicionarmos o nome da página no campo `Clear Cache`, forçamos o APEX a "resetar" a página de destino antes de a mostrar, garantindo uma navegação limpa e evitando este problema. **É uma boa prática a adotar em redirecionamentos dinâmicos.**

   

3. Clique em **Save**.

#### **4.4. Testar, Expandir e Diagnosticar**

1. **Testar:** Faça login como `COORD_TESTE`. Verifique se consegue navegar para a página `Gestão de Cursos` e se consegue **editar** os dados (ex: clicando duas vezes numa célula). Tente fazer login como `TECNICO_TESTE` e confirme que o menu "Central de Configurações" não aparece.  
     
2. **Expandir:** Para adicionar as outras tabelas de catálogo:  
     
   * Crie a página **Interactive Grid**, lembrando-se de:  
     1. **Desativar** a entrada de menu.  
     2. Definir um **Alias** único.  
     3. Aplicar a segurança `is_coordenador`.  
     4. **Verificar** se a edição está ativa e a chave primária está definida (passo 4.2.1).  
   * Vá à página `CENTRAL_CONFIG` e adicione a nova opção à lista de seleção `P2_PAGINA_ALVO`.

   

3. **Troubleshooting (Se os Problemas Voltarem):**  
     
   * **Problema de Acesso (Loop de Login):**  
     1. Verifique se aplicou o esquema de autorização `is_coordenador` à página "Spoke".  
     2. Verifique se a configuração do "Branch" na página "Hub" inclui o valor no campo `Clear Cache`, como descrito no passo 4.3.  
   * **Problema de Edição (Grelha não editável):**  
     1. Execute a checklist do passo 4.2.1: verifique o interruptor "Edit \> Enabled" nos "Attributes" da grelha e o campo "Primary Key Column" na "Source" da região.

**Conclusão:** Ao seguir este guia consolidado, implementou a "Sala de Controlo" de uma forma que não só é funcional e segura, mas também robusta, manutenível e com uma experiência de utilizador superior, incorporando já as soluções para os problemas mais comuns neste tipo de implementação.  