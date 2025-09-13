# **Plano de Implementação Faseado: Passaporte Competências Digitais (Detalhado)**

Este documento delineia o plano de implementação completo para a aplicação, estruturado em fases lógicas. O objetivo é construir a aplicação de forma incremental sobre uma fundação técnica completa, garantindo que cada fase entrega valor funcional e nos aproxima progressivamente da visão final definida na "Experiência do Utilizador".

## **Fase 1: A Fundação Completa (Setup Robusto)**

**Objetivo:** No final desta fase, teremos a infraestrutura, a totalidade da estrutura de dados e o modelo de segurança final da aplicação implementados. Teremos uma "tela em branco" perfeitamente preparada, robusta e segura, pronta para receber as funcionalidades.

* ### **Passo 1: A Fundação (Setup da Infraestrutura)**

  * **Descrição:** Este passo consiste em preparar o ambiente na Oracle Cloud. É o pré-requisito técnico para todo o projeto.  
  * **Ações Detalhadas:**  
    1. Criar uma conta no serviço "Always Free" da Oracle Cloud.  
    2. Provisionar uma instância da "Autonomous Transaction Processing Database".  
    3. Criar um schema de base de dados dedicado (ex: PASSAPORTE\_APP).  
    4. Criar um Workspace Oracle APEX associado a esse schema.  
  * **Resultado:** Um ambiente de desenvolvimento APEX funcional, ligado a uma base de dados autónoma e segura.

* ### **Passo 2: A Estrutura Central (Modelo de Dados Completo)**

  * **Descrição:** Este passo crucial traduz o nosso **Modelo de Dados v4.0** na sua totalidade para uma estrutura de base de dados real. A versão final do modelo inclui a tabela central `Utilizadores`, garantindo a integridade de todo o sistema. Ao final, todas as tabelas, colunas e relações necessárias para a aplicação final estarão criadas.  
  * **Ações Detalhadas:**  
    1. Executar o script SQL de criação de tabelas (versão final, baseada no Modelo v4.0).  
    2. Este script irá criar **todas as tabelas de lookup** (ex: TIPOS\_ESTADO\_TURMA) e populá-las com os valores iniciais.  
    3. De seguida, criará **todas as tabelas de catálogo e operacionais** (PROGRAMAS, INSCRITOS, TURMAS, etc.), já com as novas colunas de ID para as chaves estrangeiras.  
    4. Finalmente, estabelecerá **todas as relações de chave estrangeira**, garantindo a integridade referencial do modelo desde o início.  
    5. Incluirá a criação das tabelas que suportam a UX avançada: TURMA\_COMPETENCIAS\_LECIONADAS e DESAFIOS\_TURMA.  
  * **Resultado:** Uma base de dados completa, robusta e perfeitamente alinhada com a visão final do projeto.

* ### **Passo 3: As Chaves do Reino (Estrutura de Segurança Completa)**

  * **Descrição:** Implementaremos a nossa arquitetura de segurança final, que é **orientada a dados (data-driven)**. As permissões serão geridas pela tabela `Utilizadores` e a lógica de verificação centralizada num pacote PL/SQL, garantindo um sistema coeso, seguro e manutenível desde o início.  
  * **Ações Detalhadas:**  
    1. Criar os três **Grupos de Utilizadores** no Workspace APEX: COORDENADORES, TECNICOS, FORMADORES.  
    2. Criar os utilizadores de teste e associá-los aos seus respetivos grupos.  
    3. Criar o pacote PL/SQL **SEGURANCA\_PKG** na base de dados. Este pacote conterá as funções que encapsulam a lógica de verificação de perfis (ex: is\_coordenador, is\_tecnico).  
    4. Criar os **Esquemas de Autorização** no APEX do tipo "PL/SQL Function Returning Boolean", que irão simplesmente chamar as funções do nosso pacote de segurança.  
    5. Executar o passo de alinhamento da segurança da aplicação, desativando o "Application Access Control" para evitar conflitos.  
  * **Resultado:** Um sistema de segurança completo, profissional e centralizado, pronto para ser aplicado às páginas e componentes que construiremos nas fases seguintes.

## **Fase 2: As Jornadas Ganham Vida (Foco na Experiência do Utilizador)**

**Objetivo:** Com o núcleo operacional a funcionar, esta fase foca-se em construir as experiências ricas e os fluxos de trabalho inteligentes que definimos para cada perfil de utilizador.

* ### **Passo 4: A Sala de Controlo do Coordenador (Hub & Spoke)**

  * **Descrição:** Construir a interface de gestão para o Coordenador, seguindo a arquitetura "Hub & Spoke" para garantir uma experiência centralizada e uma implementação robusta.  
  * **Ações Detalhadas:**  
    1. Criar a página "Hub" chamada **"Central de Configurações"**, com uma lista de seleção para todas as tabelas de lookup, de catálogo e para a nova interface de **gestão de utilizadores**.  
    2. Para cada item nessa lista, criar uma página de gestão "Spoke" dedicada (do tipo Interactive Grid), sem entrada no menu de navegação.  
    3. Implementar a lógica de "Branches" (redirecionamento) na página "Hub" para que, ao selecionar uma opção, o utilizador seja levado para a página "Spoke" correspondente.  
    4. Proteger todas estas páginas com o esquema de autorização is\_coordenador.  
  * **Resultado:** O Coordenador tem total autonomia para gerir todos os parâmetros da aplicação, cumprindo a sua jornada de "Configuração".

* ### **Passo 5: O Funil de Entrada Inteligente (Jornada do Técnico)**

  * **Descrição:** Construir o fluxo de trabalho para o Técnico processar novas pré-inscrições, com as validações automáticas previstas na UX.  
  * **Ações Detalhadas:**  
    1. Criar a página de relatório **"Novas Pré-Inscrições"**, filtrada para mostrar apenas os registos com o estado correspondente a "Nova" (usando a tabela de lookup).  
    2. Criar a página modal **"Processar Pré-Inscrição"**, baseada na tabela INSCRITOS.  
    3. Implementar o processo PL/SQL "Pre-Rendering" que, ao abrir a página, verifica se o NIF/email da pré-inscrição já existe na tabela INSCRITOS.  
    4. Implementar a lógica condicional: se for novo, pré-preenche o formulário; se já existir, carrega os dados existentes e mostra uma mensagem de aviso.  
    5. Configurar os botões de "Criar" e "Atualizar" para aparecerem condicionalmente.  
    6. Implementar o processo "After Submit" que atualiza o estado da pré-inscrição para "Convertida".  
  * **Resultado:** O Técnico tem um fluxo de trabalho eficiente e à prova de erros para o onboarding de novos participantes.

* ### **Passo 6: Gestão de Turmas e Matrículas (Jornada do Técnico)**

  * **Descrição:** Construir as ferramentas essenciais para o Técnico criar e gerir turmas e matricular formandos.  
  * **Ações Detalhadas:**  
    1. Criar a página de relatório **"Gestão de Turmas"**.  
    2. Criar a página de formulário **"Detalhe da Turma"**, usando listas de seleção dinâmicas para os campos de ID (ex: id\_estado\_turma).  
    3. Na página de detalhe, adicionar uma região de relatório para mostrar os inscritos já matriculados naquela turma.  
    4. Implementar o fluxo de matrícula: um botão que abre uma página modal com uma grelha de seleção dos Inscritos "Ativos" que ainda não estão naquela turma.  
    5. Criar o processo que, ao submeter essa grelha, insere os novos registos na tabela MATRICULAS.  
  * **Resultado:** O Técnico consegue gerir o ciclo de vida de uma turma, desde a sua criação até à inscrição dos formandos.

## **Fase 3: Funcionalidades Avançadas e Fecho do Ciclo**

**Objetivo:** Implementar as funcionalidades mais inovadoras da nossa UX, focando-nos nas jornadas do Formador e do Formando, e nas ferramentas de análise para o Coordenador.

* ### **Passo 7: O Cockpit do Formador**

  * **Descrição:** Construir o portal dedicado ao Formador, centralizando todas as suas ferramentas de trabalho.  
  * **Ações Detalhadas:**  
    1. Criar a página **"As Minhas Turmas"**, com um relatório filtrado automaticamente para mostrar apenas as turmas associadas ao formador logado.  
    2. Criar a página de detalhe da turma para o formador (o "cockpit"), que irá incluir:  
       * Uma região para o registo de **presenças e sumários** por sessão.  
       * Uma região para gerir os **recursos pedagógicos** (URL\_Recursos\_Pedagogicos) de cada sessão.  
       * Uma grelha para selecionar as **competências efetivamente lecionadas** (que irá popular a tabela Turma\_Competencias\_Lecionadas).  
  * **Resultado:** O Formador tem uma ferramenta de trabalho diário que simplifica a sua administração e apoia a sua atividade pedagógica.

* ### **Passo 8: A Cerimónia de Finalização**

  * **Descrição:** Construir o fluxo que permite ao Formador gerar o "link mágico" e a experiência interativa que o Formando utiliza para concluir o curso.  
  * **Ações Detalhadas:**  
    1. No "Cockpit do Formador", criar o processo que gera um token\_acesso único, constrói o URL e insere o registo na tabela DESAFIOS\_TURMA.  
    2. Criar uma nova **página pública** (sem necessidade de login) na aplicação.  
    3. Implementar a lógica nessa página para ler o token do URL, identificar o formando e a turma, e guiá-lo interativamente pelos passos: (1) link para o Desafio Final, (2) botão para verificar e copiar respostas, (3) links para reclamar as medalhas, (4) link para a avaliação de satisfação.  
  * **Resultado:** A aplicação oferece a experiência de finalização de curso memorável e recompensadora que idealizámos.

* ### **Passo 9: A Matriz de Gestão Global (Jornada do Técnico)**

  * **Descrição:** Implementar a ferramenta de gestão operacional mais poderosa para o Técnico, a "Matriz 360°", que proporciona uma visão completa do percurso de todos os inscritos em todos os cursos do programa.  
  * **Ações Detalhadas:**  
    1. Criar uma nova página de aplicação chamada **"Matriz de Matrículas"**.  
    2. Desenvolver uma consulta SQL avançada, utilizando a função PIVOT ou uma função PL/SQL que retorna uma query dinâmica, para transformar os dados de MATRICULAS numa grelha onde as linhas são os Inscritos e as colunas são os Cursos.  
    3. Implementar esta consulta num componente de relatório (provavelmente um "Classic Report" com HTML personalizado para permitir interatividade, ou um "Interactive Report" com configuração avançada).  
    4. Adicionar a lógica que permite ao Técnico alterar o estado de uma matrícula diretamente na matriz (ex: de "Aguardando matrícula" para uma turma específica), através de listas de seleção dinâmicas e processos de página.  
    5. Proteger a página com o esquema de autorização is\_tecnico.  
  * **Resultado:** O Técnico ganha uma ferramenta de supervisão e ação sem precedentes, que lhe dá uma visão completa e acionável do percurso de todos os participantes.

* ### **Passo 10: A Ferramenta de Gestão Operacional de Formandos (Novo)**

* **Descrição:** Construir a interface de gestão diária para o Técnico, permitindo-lhe filtrar formandos por curso e turma e executar ações em massa, como enviar comunicações ou gerar listas de participantes, conforme definido na "Fase 5" da sua jornada.  
* **Ações Detalhadas:**  
  * Criar uma nova página de aplicação chamada **"Gestão de Formandos"** e protegê-la com o esquema de autorização `is_tecnico`.  
  * Adicionar duas regiões de filtro no topo da página:  
    1. Um item do tipo "Select List" para a seleção do **Curso**, que irá listar todos os cursos da tabela `CURSOS`.  
    2. Um item do tipo "Select List" para a seleção da **Turma**, que será preenchido dinamicamente com base no curso selecionado (Cascading Select List).  
  * Criar a região principal da página com um componente **"Interactive Report"** para apresentar a lista de formandos. A consulta SQL para este relatório deverá fazer  
     `JOIN` entre as tabelas `INSCRITOS`, `MATRICULAS`, `TURMAS` e `CURSOS` para apresentar todas as colunas necessárias. O relatório deverá ser filtrado com base nos valores dos itens de seleção de curso and turma.  
  * Ativar a funcionalidade de seleção de linhas (checkbox) no Interactive Report para permitir que o Técnico selecione um ou mais formandos.  
  * Adicionar botões na região do relatório para as ações em massa:  
    1. **"Gerar Lista Simples":** Este botão irá despoletar um processo para exportar os dados dos formandos selecionados para um ficheiro (ex: CSV ou PDF).  
    2. **"Enviar Email":** Este botão irá recolher os emails dos formandos selecionados, abrir uma janela modal para a redação de um email (possivelmente pré-preenchido com um template da tabela `Modelos_De_Comunicacao`) e enviá-lo.  
    3. **"Registar Presenças":** Este botão irá redirecionar o técnico para uma nova página ou modal onde poderá registar as presenças para os formandos selecionados numa sessão específica da turma.  
* **Resultado:** O Técnico ganha uma ferramenta focada e poderosa para a gestão operacional do dia a dia de turmas específicas, complementando a visão macro da "Matriz de Gestão Global".

* ### **Passo 11: O Dashboard Estratégico (Jornada do Coordenador)**

  * **Descrição:** Construir o painel de controlo visual para o Coordenador, fornecendo uma visão macro e em tempo real da saúde e do impacto do programa.  
  * **Ações Detalhadas:**  
    1. Editar a Página Inicial (Home) da aplicação.  
    2. Adicionar várias regiões do tipo **"Chart"** (Gráfico) para visualizar dados chave, como: "Inscritos por Situação Profissional", "Badges Emitidos por Mês", "Turmas por Estado".  
    3. Para cada gráfico, escrever a consulta SQL de agregação correspondente (usando COUNT, GROUP BY, etc.).  
    4. Adicionar regiões do tipo **"Card"** (Cartão) para destacar os Indicadores-Chave de Desempenho (KPIs) mais importantes: "Total de Inscritos Ativos", "Taxa de Conclusão Média", "Nº de Pré-Inscrições Pendentes".  
    5. Garantir que todas estas regiões de dashboard estão protegidas com o esquema de autorização is\_coordenador, para que apenas este perfil as possa ver.  
  * **Resultado:** O Coordenador tem as ferramentas de que precisa para a supervisão estratégica, a tomada de decisão baseada em dados e a preparação de relatórios de impacto.

* ### **Passo 12 (Futuro): O Portal do Formando**

  * **Descrição:** Desenhar e construir a área pessoal segura onde o formando pode visualizar o seu "Passaporte Digital" com todos os badges que já conquistou, consultar o seu histórico e descarregar certificados.  
  * **Ações Detalhadas:**  
    1. Configurar um esquema de autenticação para os formandos (que pode ser diferente do dos utilizadores internos).  
    2. Criar uma página de perfil que, após o login, mostra os dados pessoais do formando.  
    3. Desenvolver uma região de relatório que consulta a tabela BADGES\_ATRIBUIDOS para mostrar uma galeria visual das medalhas conquistadas.  
    4. Implementar a funcionalidade para descarregar certificados, ligando ao campo URL\_Certificado\_Conclusao na tabela MATRICULAS.  
  * **Resultado:** O programa entrega um produto final tangível e de valor para o cidadão, completando a sua jornada de reconhecimento.
