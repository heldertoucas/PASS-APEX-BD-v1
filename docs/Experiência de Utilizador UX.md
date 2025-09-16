### **Experiência de Utilizador (UX): Aplicação Passaporte Competências Digitais**

**Propósito do Documento:** Este documento descreve a aplicação "Passaporte Competências Digitais" não pela sua estrutura técnica, mas pela perspetiva das pessoas que a irão utilizar. O objetivo é mapear as jornadas dos diferentes tipos de utilizador para guiar o desenvolvimento de uma ferramenta coesa, centrada no ser humano e que responde eficazmente às necessidades de cada interveniente.

#### **1\. Os Nossos Utilizadores: Perfis e Motivações**

Identificamos quatro perfis de utilizador distintos, cada um com objetivos e necessidades específicas dentro do ecossistema do programa:

* **O Coordenador:** O estratega. A sua principal motivação é **configurar, supervisionar e medir o impacto** do programa. Precisa de uma visão macro, de ferramentas para definir os parâmetros da oferta formativa e de acesso a dados analíticos para a tomada de decisão.  

  > *Como Coordenador, quero poder gerir os utilizadores do sistema (Técnicos, Formadores) e as suas respetivas funções, para garantir que cada um tem acesso apenas às funcionalidades necessárias para o seu trabalho.*  
    
* **O Técnico:** O operador. É o pilar da gestão do dia a dia. A sua motivação é  
  **processar eficientemente o fluxo de cidadãos**, desde o interesse inicial até à conclusão da formação, garantindo a qualidade e a integridade dos dados operacionais.  
    
* **O Formador:** O facilitador. Está na linha da frente da formação. A sua motivação é  
  **gerir as suas turmas e registar o progresso dos formandos** de forma simples e rápida, para se poder focar no ensino.  
    
* **O Formando (Cidadão):** O beneficiário. É a razão de ser do programa. A sua motivação é **adquirir novas competências, ver o seu progresso reconhecido** e ter uma prova tangível das suas conquistas através do passaporte digital.

#### **2\. A Jornada do Utilizador: Fluxos e Interações Chave**

A aplicação materializa-se através das jornadas interligadas destes quatro perfis.

##### **A. A Jornada do Coordenador (A Visão Estratégica)**

Um **Coordenador**, como o utilizador **"Coordenador Teste"**, utiliza a aplicação para construir e supervisionar o programa.

1. **Fase de Configuração:** O Coordenador acede a um "back-office" de gestão de catálogos para "mobilar" a aplicação. É aqui que ele define:  
     
   * Os **Programas** de formação (ex: "Passaporte Competências Digitais").  
       
   * O catálogo mestre de **Competências** alinhadas com o modelo DigComp, incluindo os ícones e medalhas digitais associadas.  
       
   * A lista completa de **Cursos** disponíveis, com os seus conteúdos, carga horária e objetivos.  
       
   * A gestão de **Utilizadores do Sistema**: Através de uma interface dedicada, o Coordenador pode criar, editar e desativar as contas dos utilizadores internos (outros Coordenadores, Técnicos e Formadores). Para cada utilizador, ele define o nome, o email de acesso e atribui uma **Função** ('COORDENADOR', 'TECNICO', 'FORMADOR'), que determinará as permissões desse utilizador dentro da aplicação.  
       
   * Os **Modelos de Comunicação** para automatizar emails e outras notificações.

   

2. **Fase de Supervisão (Futuro):** O Coordenador acede a um dashboard principal com métricas e gráficos que lhe dão o pulso do programa em tempo real: número de inscritos, turmas ativas, taxa de conclusão, etc.  

> **Nota de Implementação:** Esta funcionalidade está planeada para uma futura iteração. A implementação atual foca-se nas jornadas operacionais.  
     
3. **Fase de Análise (Futuro):** O Coordenador gera relatórios detalhados para analisar o impacto do programa, cruzar dados demográficos com o sucesso na formação e preparar reportes para entidades superiores.

> **Nota de Implementação:** Esta funcionalidade está planeada para uma futura iteração. A implementação atual foca-se nas jornadas operacionais.

##### **B. A Jornada do Técnico (O Fluxo Operacional)**

O Técnico é o utilizador mais frequente da aplicação, garantindo que a "máquina" do programa funciona sem percalços.

1. **Fase 1: Funil de Entrada (Onboarding do Cidadão):**  
     
   * Um **Técnico**, como o **"Técnico Teste"**, inicia o seu dia na página **"Novas Pré-Inscrições"**. Esta página é a sua caixa de entrada, mostrando, por exemplo, as novas submissões de **"Joana Silva (Teste Novo)"** e **"Maria Martins (Teste Duplicado)"**.
       
   * Ao clicar na pré-inscrição de **"Joana Silva"**, o assistente inteligente verifica que o seu NIF (444555666) não existe na base de dados. O formulário de novo Inscrito é então pré-preenchido com os dados dela.
   
   * No entanto, ao clicar na pré-inscrição de **"Maria Martins"**, o sistema deteta que o seu NIF (123456789) já corresponde a um registo existente ("Maria Lúcia Martins"). Em vez de criar um duplicado, a aplicação carrega o perfil existente de Maria para que o técnico possa verificar os dados e atualizar os seus interesses.
       
   * Com um clique, o Técnico conclui o perfil do novo Inscrito (Joana), que passa a estar "Ativo", e a pré-inscrição original é arquivada. No caso de Maria, o técnico apenas atualiza o seu registo.

   

2. **Fase 2: Gestão Académica:**  
     
   * O Técnico acede à área de **"Gestão de Turmas"** para planear novas ações de formação.  
       
   * Ele cria uma nova Turma, associa-a a um Curso do catálogo, define o local, as datas, as vagas e atribui os Formadores e o Coordenador responsáveis.

   

3. **Fase 3: Matrícula de Formandos:**  
     
   * Dentro da página de detalhe de uma turma, o Técnico clica em "Matricular Novos Inscritos".  
       
   * A aplicação apresenta todos os formandos "Ativos" que  
     **ainda não estão nessa turma**, prevenindo erros de matrícula.  
       
   * O Técnico seleciona os formandos e confirma a matrícula, que fica imediatamente registada.

   

4. **Fase 4: Gestão Global de Matrículas:**  
     
   * O Técnico acede à área de **"Gestão de Matrículas"** para gerir todas as matrículas nos cursos do programa.  
       
   * A aplicação apresenta um quadro muito completo, que resulta da consulta de dados em várias tabelas diferentes. O quadro inclui o nome, email, idade, habilitação e observações de todos os inscritos; inclui ainda uma coluna para cada um dos cursos do programa (se o programa tiver 10 cursos, o quadro apresentará 10 tabelas); na coluna de cada curso aparece a informação mais recente sobre dado inscrito relativa ao curso, por exemplo “concluiu a ação X”, “a frequentar a ação Y”, falta justificada à ação Z”, “aguarda matrícula”, “inscrição suspensa”, etc.  
       
   * O Técnico tem uma visão 360 de todos os inscritos e pode, neste quadro, alterar o estado dos que “aguarda matrícula” e inscrevê-los, através de uma lista de valores, nas ações ainda por realizar de um dado curso. Ao carregar em “guardar”, um resumo das alterações são apresentadas ao técnico numa mensagem, que confirma e ordena a aplicação que inscreve os cidadãos nas turmas.  
       
5. **Fase 5: Gestão Global de Formandos:**  
     
   * O Técnico acede à área de "Gestão de Formandos" e a aplicação apresenta um quadro com dois filtros de seleção, curso e turma. Abaixo dos filtros é apresentado dinamicamente a lista dos cidadãos matriculados no curso/ação. O quadro inclui o nome, email, telemóvel e observações dos cidadãos matriculados e ainda dados sobre o Curso/ação: curso, ação, data de Início, data de Conclusão, Local e formadores.  
   * O quadro permite seleccionar um ou mais cidadãos matriculados. Com base na selecção de cidadãos, esta página permitirá criar: registo de presenças, lista simples de participantes, envio de emails aos participantes, como o email de convocatória, etc.

**C. A Jornada do Formador (A Interação em Sala e Fora Dela)**

Um **Formador**, como o **"Formador Teste"**, interage com a aplicação de forma focada e pragmática. A ferramenta deve ser um aliado que simplifica a burocracia para que ele se possa concentrar no que faz de melhor: provocar aprendizagens.

* **Fase de Preparação:** O **"Formador Teste"** acede ao seu portal, "As Minhas Turmas". Para a turma **"PCD-C1-Marvila-01"**, a aplicação funciona como o seu "cockpit", apresentando:  
    
  * **A Lista de Formandos:** Incluindo **"Maria Lúcia Martins"** e **"Carlos Miguel Ferreira"**.  
  * **O Calendário de Sessões:** Com acesso rápido a cada aula, como a "Sessão 1" de 08/09/2025.  
  * **O Repositório de Recursos:** Links diretos para os materiais pedagógicos.  
  * **Check-list de Preparação:** Um guia simples para garantir que nada falha.


* **Fase de Execução (Registo da Sessão):** No final da "Sessão 1", o momento crítico. A aplicação oferece flexibilidade máxima:  
    
  * O **"Formador Teste"** acede à página de registo de presenças através do seu portal, de um **link direto** ou de um **QRCode**, permitindo um acesso instantâneo nos seus dispositivos.  
  * A interface é uma grelha limpa e rápida. Com poucos cliques, marca **"Maria Lúcia Martins"** como "Presente" e **"Carlos Miguel Ferreira"** como "Ausente".  
  * Na mesma página, preenche o **Sumário** da sessão, descrevendo as atividades e competências abordadas, e adiciona observações pertinentes. Um clique em "Guardar" submete tudo de uma só vez.


* **Fase de Encerramento e Administração:**  
    
  * **O Momento da Verdade (Última Sessão):** É o Formador quem orquestra o início da fase final. Ele acede à sua área da turma, ativa ou desativa as competências associadas ao curso que foram efetivamente concretizadas na ação de formação que realizou e a aplicação gera em seguida um **link único e exclusivo para o "Desafio Digital Final" daquela turma específica**. Este link é o "código" que ele fornece aos formandos para iniciarem a sua avaliação.  
  * **Conclusão da Turma:** No seu portal, uma check-list final guia o Formador para garantir que todos os sumários e presenças estão preenchidos. Com um clique em "Concluir Turma", ele submete o seu relatório de satisfação e o sistema arquiva a turma, sinalizando ao Técnico que o ciclo está completo.

Durante o curso, a secção Gestão do Dossier Técnico-Pedagógico está disponível a técnicos, coordenadores e formadores e permite consultar e imprimir documentos essenciais para o dossier:

* Lista de Participantes atualizada.  
  * Folha de Presenças consolidada com todas as sessões.  
    * Relatório de Sumários completo.

**D. A Jornada do Formando (A Experiência Central e de Reconhecimento)**

Esta é a jornada mais importante, a experiência de uma cidadã como a **"Maria Lúcia Martins"**. Deve ser fluida, encorajadora e culminar num sentimento de conquista.

* **Fase de Descoberta:** O cidadão encontra o programa online ou num balcão de atendimento e manifesta o seu interesse ao preencher um formulário de Pre\_Inscricoes.  
    
* **Fase de Onboarding:** O cidadão é contactado pela equipa, os seus dados são validados e é formalmente criado como Inscrito na plataforma. Recebe uma comunicação de boas-vindas e a convocatória para a sua primeira turma.  
    
* **Fase de Participação:** O cidadão frequenta as sessões de formação. O seu progresso (presenças) é registado pelo Formador na aplicação.  
    
* **Fase de Avaliação e Conquista (A Cerimónia de Finalização):** Esta fase não é uma simples avaliação; é uma **experiência integrada e interativa**, desenhada para ser o clímax do curso. Na última sessão, o Formador partilha o link mágico. Ao clicar, o formando não entra num formulário frio, mas sim numa **página de aterragem personalizada e acolhedora**.  
    
  * **Passo 1: O Desafio Final.** A página apresenta um botão claro e apelativo: **"Iniciar Desafio Final"**. Ao clicar, o formando é levado para o questionário de avaliação (ex: Google Form). A tecnologia funciona nos bastidores: um token único já foi associado a ele, garantindo que as suas respostas serão corretamente identificadas. Ele preenche o desafio e submete.  
      
  * **Passo 2: A Validação e a Recompensa Imediata.** O formando regressa à página da cerimónia. Agora, o próximo passo está disponível. Ele clica em **"Verificar Respostas e Obter Medalha 1"**. A magia acontece aqui:  
      
    1. A página exibe uma mensagem animada: *"A procurar as suas respostas..."*.  
    2. Segundos depois, a mensagem muda: **"🎉 Sucesso\! As suas respostas foram encontradas e copiadas para a sua área de transferência."** Neste exato momento, o formando já tem um registo completo das suas respostas pronto a ser colado onde quiser, e um email de confirmação está a caminho da sua caixa de correio.  
    3. A própria página atualiza-se para exibir as suas respostas, permitindo-lhe revê-las.  
    4. Finalmente, o botão cumpre a sua promessa: o link para a **plataforma de medalhas digitais** (ex: Lisboa Cidade de Aprendizagem) abre-se automaticamente, para que ele possa reclamar a sua primeira recompensa. O link de acesso à medalha digital a conquistar corresponde ao campo `linkBadgeLCA` de todas as competências associadas ao curso e ativadas pelo formador do ação no momento de criação de um link mágico.  
    5. O formando regressa à página da cerimónia após a conquista de cada medalha digital, até terminar a conquista de todas as medalhas digitais disponíveis. O sistema regista a emissão de um ou mais `Badges_Atribuidos`, que certificam as competências adquiridas.

    

  * **Passo 3: A Avaliação da Experiência.** De volta à página, um último botão aguarda: **"Avaliar o Curso"**. Um clique leva-o diretamente ao formulário de satisfação (ex: Microsoft Forms), também ele pré-preenchido com dados do curso para facilitar o processo.


  Toda esta sequência transforma o que poderia ser uma tarefa administrativa numa jornada recompensadora, guiada e sem atritos, que reforça o sentimento de realização.


* **Fase de Reconhecimento:** Ao concluir um curso com sucesso, e executar todas as etapas da "Cerimónia de Finalização", o sistema regista esta conquista (`Matriculas.Estado = 'Concluído com Sucesso'`).  
    
* **Fase de Autonomia (Futuro):** O formando acede a um Portal Pessoal online. Nesta área reservada, ele pode:  

> **Nota de Implementação:** A criação do Portal do Formando é uma funcionalidade majoritária planeada para uma futura versão. As colunas para suportar esta funcionalidade (ex: `URL_CERTIFICADO_CONCLUSAO`) existem na base de dados, mas a interface e a lógica de negócio ainda não estão implementadas.  
    
  * Visualizar o seu "Passaporte Competências Digitais": uma galeria visual com todos os badges que já conquistou.  
  * Clicar num badge para ver os detalhes da competência e aceder ao link do Open Badge (`linkBadgeLCA`).  
  * Consultar o seu percurso e o histórico de formações.  
  * Descarregar os seus certificados de participação em formato PDF, através de um link de acesso ao repositório onde estão guardados (funcionalidade a desenvolver no futuro).
