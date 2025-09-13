# **Modelo de Dados Consolidado: Passaporte Competências Digitais**

**Versão:** 4.0 (UX-Driven)

**Data:** 4 de agosto de 2025

**Autor:** HT

## **1\. Introdução**

Este documento detalha o modelo de dados unificado e agnóstico para a aplicação de gestão "Passaporte Competências Digitais". O seu propósito é servir como a única fonte de verdade para a estrutura de dados, independentemente da plataforma tecnológica escolhida para a sua implementação.

**Evolução (v4.0):** Esta versão foi enriquecida com base num mapeamento detalhado da **Experiência do Utilizador (UX)**. As alterações introduzidas visam suportar diretamente as jornadas específicas do Coordenador, Técnico, Formador e Formando, acrescentando a granularidade necessária para implementar funcionalidades mais ricas, como a gestão de recursos pedagógicos por sessão, o controlo de competências efetivamente lecionadas e a inovadora "Cerimónia de Finalização" do curso.

## **2\. Entidades de Catálogo e Configuração**

Estas entidades contêm os dados de referência que raramente mudam e servem de base para o funcionamento do programa.

### **2.1. Tabela: Programas**

**Propósito:** Catálogo dos diferentes programas ou iniciativas de formação que a organização gere. Esta é a entidade de topo que agrupa os cursos.

| Nome do Campo | Tipo de Dados Sugerido | Descrição / Propósito |
| :---- | :---- | :---- |
| ID\_Programa | Identificador Único (PK) | Chave primária única para cada programa. |
| Nome | Texto (Curto, Único) | O nome oficial do programa (ex: "Passaporte Competências Digitais"). |
| Descricao | Texto (Longo) | Uma breve descrição dos objetivos e público-alvo do programa. |

### **2.2. Tabela: Competencias**

**Propósito:** Armazena o catálogo mestre das competências digitais abrangidas pelo programa, alinhadas com o modelo DigComp.

| Nome do Campo | Tipo de Dados Sugerido | Descrição / Propósito |
| :---- | :---- | :---- |
| ID\_Competencia | Identificador Único (PK) | Chave primária única para cada competência. |
| Nome | Texto (Curto) | O nome oficial da competência (ex: "Cidadania Digital"). |
| Descricao | Texto (Longo) | Descrição detalhada da competência. |
| ID\_Area\_Competencia | Relação (FK) | Referência à área da competência na tabela Tipos\_Area\_Competencia. |
| ID\_Nivel\_Proficiencia | Relação (FK) | Referência ao nível de proficiência na tabela Tipos\_Nivel\_Proficiencia. |
| URL\_Medalha\_Digital | URL / Hiperligação | O link único para a conquista da medalha digital associada a esta competência. |
| URL\_Icone\_Badge | URL / Hiperligação | O link para o ficheiro de imagem (.svg, .png) do ícone visual do badge. |

### **2.3. Tabela: Cursos**

**Propósito:** O catálogo completo de todos os cursos de formação disponíveis, cada um associado a um programa específico.

| Nome do Campo | Tipo de Dados Sugerido | Descrição / Propósito |
| :---- | :---- | :---- |
| ID\_Curso | Identificador Único (PK) | Chave primária única para cada curso. |
| ID\_Programa | Relação (FK) | Referência ao programa ao qual o curso pertence na tabela Programas. |
| Nome | Texto (Curto) | O nome oficial do curso. |
| ID\_Estado\_Curso | Relação (FK) | Referência ao estado do curso na tabela Tipos\_Estado\_Curso. |
| Carga\_Horaria | Numérico (Inteiro) | Duração total do curso em horas. |
| Competencias\_Associadas | Relação Múltipla (FK) | Referência a uma ou mais competências da tabela Competencias que são abordadas neste curso. |
| Modalidade\_Formacao | Texto (Curto) | A modalidade geral da formação (ex: "Formação contínua"). |
| Forma\_Organizacao | Texto (Curto) | O formato de entrega do curso (ex: "Presencial", "Online (síncrona)", "Híbrido"). |
| Publico\_Alvo | Texto (Longo) | Descrição detalhada dos destinatários preferenciais do curso. |
| Objetivos\_Gerais | Texto (Longo, Formatado) | Os objetivos de aprendizagem gerais do curso. |
| Objetivos\_Especificos | Texto (Longo, Formatado) | Os objetivos de aprendizagem detalhados e específicos. |
| Conteudos\_Programaticos | Texto (Longo, Formatado) | A lista de tópicos e conteúdos abordados no curso. |
| Metodologia\_Avaliacao | Texto (Longo) | Descrição dos métodos e critérios de avaliação utilizados no curso. |
| URL\_Manual\_Digital | URL / Hiperligação | Link para o manual digital ou material de apoio principal do curso. |

### **2.4. Tabela: Tipos\_De\_Qualificacao**

**Propósito:** Tabela de suporte com os níveis de habilitações literárias e a sua correspondência com o Quadro Europeu de Qualificações (QEQ).

| Nome do Campo | Tipo de Dados Sugerido | Descrição / Propósito |
| :---- | :---- | :---- |
| ID\_Qualificacao | Identificador Único (PK) | Chave primária única para cada tipo de qualificação. |
| Nome | Texto (Curto) | O nome da qualificação (ex: "Ensino Secundário", "Mestrado"). |
| Nivel\_QEQ | Numérico (Inteiro) | O nível correspondente no Quadro Europeu de Qualificações (1 a 8). |
| Descricao | Texto (Longo) | Descrição mais detalhada da qualificação, se necessário. |

### **2.5. Tabela: Modelos\_De\_Comunicacao**

**Propósito:** Armazena os templates para comunicações (ex: emails), permitindo a sua edição sem necessidade de alterar o código da aplicação.

| Nome do Campo | Tipo de Dados Sugerido | Descrição / Propósito |
| :---- | :---- | :---- |
| ID\_Modelo | Identificador Único (PK) | Chave primária única para cada modelo. |
| Nome | Texto (Curto) | Nome interno para identificar o modelo (ex: "Email de Boas-Vindas"). |
| Assunto | Texto (Curto) | O assunto pré-preenchido do email ou comunicação. |
| Corpo | Texto (Longo, Formatado) | O corpo da mensagem, com suporte para formatação e placeholders (ex: {NomeInscrito}, {NomeCurso}). |
| ID\_Tipo\_Notificacao | Relação (FK) | Referência ao tipo de notificação na tabela Tipos\_Notificacao. |
| Evento\_Gatilho | Texto (Curto) | Descrição do evento que despoleta a notificação (ex: "Inscrição confirmada"). |

### **2.6. Tabela: Configuracoes\_Formulario**

**Propósito:** Armazena os mapeamentos técnicos entre os campos da base de dados e os campos de formulários externos (Google Forms, Microsoft Forms, etc.), permitindo a geração de links pré-preenchidos.

| Nome do Campo | Tipo de Dados Sugerido | Descrição / Propósito |
| :---- | :---- | :---- |
| ID\_Configuracao | Identificador Único (PK) | Chave primária da configuração. |
| Nome | Texto (Curto) | Um nome para esta configuração (ex: "Desafio Digital Final V1", "Avaliação de Curso Padrão"). |
| Tipo\_Formulario | Lista de Escolha | O tipo de formulário (ex: "Google Form", "Microsoft Form"). |
| ID\_Formulario\_Externo | Texto (Curto) | O ID do formulário (ex: o GOOGLE\_FORM\_ID). |
| URL\_Base | URL / Hiperligação | O link base do formulário, sem campos pré-preenchidos. |
| Mapeamento\_Campos | JSON | Armazena a "tradução" dos campos da base de dados para os campos do formulário. Ex: {"nome\_curso": "entry.123", "nome\_formador\_1": "entry.456"}. |

### **2.7. Tabela: Tipos\_Equipamento**

**Propósito:** Catálogo de todos os tipos de equipamentos (webcams, kits de robótica, etc.) que podem ser alocados às ações de formação.

| Nome do Campo | Tipo de Dados Sugerido | Descrição / Propósito |
| :---- | :---- | :---- |
| ID\_Tipo\_Equipamento | Identificador Único (PK) | Chave primária única para cada tipo de equipamento. |
| Nome | Texto (Curto, Único) | Nome ou modelo do equipamento (ex: "Webcam Logitech C920", "Kit Micro:bit V2"). |
| Descricao | Texto (Longo) | Descrição detalhada do equipamento e das suas características. |
| ID\_Categoria\_Equipamento | Relação (FK) | Referência à categoria do equipamento na tabela Tipos\_Categoria\_Equipamento. |

### **2.8. Tabela: Utilizadores**

**Propósito:** A tabela central para todos os utilizadores internos do sistema (Coordenadores, Técnicos, Formadores). Esta tabela é a fonte de verdade para a autenticação e para o modelo de segurança baseado em funções.

| Nome do Campo | Tipo de Dados Sugerido | Descrição / Propósito |
| :--- | :--- | :--- |
| ID_Utilizador | Identificador Único (PK) | Chave primária única para cada utilizador. |
| Nome_Completo | Texto (Curto) | O nome completo do utilizador. |
| Email | Texto (Email, Único) | O email do utilizador, usado para login e como chave de negócio única. |
| Funcao | Texto (Curto) | A função do utilizador no sistema (ex: 'COORDENADOR', 'TECNICO', 'FORMADOR'). Controla as permissões. |
| Ativo | Booleano ('S'/'N') | Indica se a conta do utilizador está ativa. Contas inativas não podem fazer login. |
| Data_Criacao | Data e Hora | Data e hora em que o registo do utilizador foi criado. |

### **2.A. Novas Entidades de Lookup (Listas de Opções Dinâmicas)**

**Propósito:** Este novo conjunto de tabelas armazena os valores para as listas de opções da aplicação. Esta arquitetura permite a gestão centralizada e dinâmica destas opções pela equipa, sem necessidade de alterações no código. Cada tabela segue uma estrutura padrão: ID, Nome (o valor exibido) e Ordem\_Exibicao.

| Nome da Tabela | Propósito |
| :---- | :---- |
| **Tipos\_Area\_Competencia** | Armazena as áreas do modelo DigComp (ex: "Segurança"). |
| **Tipos\_Nivel\_Proficiencia** | Armazena os níveis de proficiência (ex: "Introdução"). |
| **Tipos\_Estado\_Curso** | Armazena os estados de um curso no catálogo (ex: "Ativo"). |
| **Tipos\_Notificacao** | Armazena os tipos de notificação (ex: "Automática"). |
| **Tipos\_Categoria\_Equipamento** | Armazena as categorias de equipamento (ex: "Hardware"). |
| **Tipos\_Estado\_Pre\_Inscricao** | Armazena os estados do funil de pré-inscrição (ex: "Nova"). |
| **Tipos\_Genero** | Armazena as opções de género (ex: "Feminino"). |
| **Tipos\_Doc\_Identificacao** | Armazena os tipos de documento de identificação (ex: "Cartão de Cidadão"). |
| **Tipos\_Situacao\_Profissional** | Armazena as situações profissionais dos inscritos (ex: "Desempregado"). |
| **Tipos\_Estado\_Geral\_Inscrito** | Armazena o estado geral de um participante no programa (ex: "Ativo"). |
| **Tipos\_Estado\_Turma** | Armazena os estados de uma turma (ex: "Em Curso"). |
| **Tipos\_Estado\_Dossier** | Armazena os estados do dossier pedagógico (ex: "Pendente"). |
| **Tipos\_Estado\_Matricula** | Armazena os estados de uma matrícula (ex: "A frequentar"). |
| **Tipos\_Nivel\_Experiencia** | Armazena os níveis de experiência auto-reportados (ex: "Iniciante"). |
| **Tipos\_Estado\_Presenca** | Armazena os estados de uma presença numa sessão (ex: "Presente"). |
| **Tipos\_Metodo\_Registo** | Armazena os métodos de registo de presença (ex: "Manual"). |
| **Tipos\_Estado\_Alocacao** | Armazena os estados de uma alocação de equipamento (ex: "Em Uso"). |
| **Tipos\_Funcao\_Turma** | Armazena as funções de um utilizador numa turma (ex: "Formador"). |
| **Tipos\_Estado\_Submissao** | Armazena os estados de submissão de um relatório (ex: "Submetido"). |

## **3\. Entidades Operacionais**

Estas entidades registam a atividade diária do programa e estão em constante atualização.

### **3.1. Tabela: Pre\_Inscricoes**

**Propósito:** Armazena os dados brutos de cada manifestação de interesse, servindo como a porta de entrada para o programa.

| Nome do Campo | Tipo de Dados Sugerido | Descrição / Propósito |
| :---- | :---- | :---- |
| ID\_Pre\_Inscricao | Identificador Único (PK) | Chave primária única para cada pré-inscrição. |
| Nome\_Completo | Texto (Curto) | Nome completo do interessado. |
| Email | Texto (Email) | Email de contacto do interessado. |
| Contacto\_Telefonico | Texto (Curto) | Número de telefone de contacto. |
| NIF | Numérico (Inteiro) | Número de Identificação Fiscal do interessado. |
| Data\_Nascimento | Data | Data de nascimento do interessado. |
| Consentimento\_Dados | Booleano | Registo do consentimento da política de privacidade. |
| Interesses | JSON / Texto (Longo) | Armazena os dados estruturados (cursos, locais, experiência) da submissão do formulário. |
| Data\_Submissao | Data e Hora | Data e hora exatas da submissão do formulário (preenchido automaticamente). |
| ID\_Estado\_Pre\_Inscricao | Relação (FK) | Referência ao estado da pré-inscrição na tabela Tipos\_Estado\_Pre\_Inscricao. |

### **3.2. Tabela: Inscritos (anteriormente Perfis)**

**Propósito:** A tabela mestre para cada indivíduo, contendo o seu perfil demográfico e de contacto. É o registo central e único de uma pessoa no programa.

| Nome do Campo | Tipo de Dados Sugerido | Descrição / Propósito |
| :---- | :---- | :---- |
| ID\_Inscrito | Identificador Único (PK) | Chave primária única para cada participante. |
| Nome\_Completo | Texto (Curto) | Nome completo oficial do participante. |
| Email | Texto (Email, Único) | Email principal do participante, usado como identificador único. |
| Contacto\_Telefonico | Texto (Curto) | Número de telefone principal. |
| NIF | Numérico (Inteiro, Único) | NIF do participante, usado como identificador único secundário. |
| Data\_Nascimento | Data | Data de nascimento. |
| ID\_Genero | Relação (FK) | Referência ao género do participante na tabela Tipos\_Genero. |
| Naturalidade | Texto (Curto) | Local de nascimento. |
| Nacionalidade | Texto (Curto) | Nacionalidade. |
| ID\_Tipo\_Doc\_Identificacao | Relação (FK) | Referência ao tipo de documento na tabela Tipos\_Doc\_Identificacao. |
| Doc\_Identificacao\_Num | Texto (Curto) | Número do documento de identificação. |
| Validade\_Doc\_Identificacao | Data | Data de validade do documento. |
| Morada | Texto (Curto) | Morada de residência. |
| Codigo\_Postal | Texto (Curto) | Código Postal de residência. |
| Localidade\_Codigo\_Postal | Texto (Curto) | Localidade de residência. |
| ID\_Situacao\_Profissional | Relação (FK) | Referência à situação profissional na tabela Tipos\_Situacao\_Profissional. |
| ID\_Qualificacao | Relação (FK) | Referência ao nível de habilitações literárias na tabela Tipos\_De\_Qualificacao. |
| Consentimento\_RGPD | Booleano | Registo do consentimento explícito do participante para o tratamento de dados, de acordo com o RGPD. |
| ID\_Estado\_Geral\_Inscrito | Relação (FK) | Referência ao estado geral do participante na tabela Tipos\_Estado\_Geral\_Inscrito. |
| Interesses\_Iniciais | JSON / Texto (Longo) | Armazena os interesses originais da primeira pré-inscrição. |
| Origem\_Inscricao | Texto (Curto) | Canal através do qual a inscrição foi feita (ex: "Formulário Online", "Sessão Presencial"). |
| Observacoes | Texto (Longo) | Campo para notas e observações gerais sobre o inscrito. |
| Data\_Criacao | Data e Hora | Data e hora em que o registo do inscrito foi criado. |

### **3.3. Tabela: Turmas**

**Propósito:** Regista cada instância de um curso para um grupo específico de formandos, com a sua informação logística.

| Nome do Campo | Tipo de Dados Sugerido | Descrição / Propósito |
| :---- | :---- | :---- |
| ID\_Turma | Identificador Único (PK) | Chave primária única para cada turma. |
| Nome | Texto (Curto) | Nome ou código da turma (ex: "NIS-T5-Lumiar"). |
| ID\_Curso | Relação (FK) | Referência ao curso correspondente na tabela Cursos. |
| Formadores | Relação Múltipla (FK) | Referência a um ou mais utilizadores do sistema (formadores) responsáveis pela turma. **Nota de Implementação:** Este campo armazena uma lista de IDs da tabela Utilizadores, separados por dois pontos (ex: '101:102'), para ser usado por componentes APEX como shuttles. |
| ID\_Coordenador | Relação (FK) | Relação (FK) para a tabela Utilizadores, identificando o coordenador responsável pela turma. |
| Numero\_Da\_Turma | Texto (Curto) | Código interno ou número sequencial da turma (ex: "Ação nº 1"). |
| ID\_Estado\_Turma | Relação (FK) | Referência ao estado da turma na tabela Tipos\_Estado\_Turma. |
| ID\_Estado\_Dossier | Relação (FK) | Referência ao estado do dossier na tabela Tipos\_Estado\_Dossier. |
| Data\_Inicio | Data | Data de início da turma. |
| Data\_Fim | Data | Data de fim da turma. |
| Local\_Formacao | Texto (Curto) | Local principal onde decorre a formação. |
| Horario | Texto (Curto) | Horário principal da turma (ex: "Pós-laboral, 19h-22h"). |
| Calendarizacao\_Texto | Texto (Longo) | Descrição textual do calendário da turma (ex: "27, 28 e 29 de abril de 2020, das 10h00 às 13h00"). |
| Estrutura\_Sessoes\_Texto | Texto (Longo) | Descrição sumária da estrutura das sessões (ex: "9 horas, distribuídas por 3 sessões de 3 horas"). |
| Vagas | Numérico (Inteiro) | Número de vagas disponíveis para a turma. |
| Total\_Inquiridos | Numérico (Inteiro) | O número de respostas recebidas no questionário de avaliação. |
| ID\_Config\_Avaliacao | Relação (FK) | Aponta para a Configuracoes\_Formulario a usar para o questionário de avaliação desta turma. |
| ID\_Config\_Desafio\_Final | Relação (FK) | Aponta para a Configuracoes\_Formulario a usar para o desafio digital desta turma. |
| **Competencias\_Para\_Desafio** | Relação Múltipla (FK) | **(Anteriormente Competencias\_Avaliadas)** Aponta para as Competencias que serão testadas no desafio digital desta turma. |
| **Competencias\_Lecionadas** | **Relação Múltipla (FK)** | **(Novo)** Referência, através da tabela Turma\_Competencias\_Lecionadas, às competências que o formador marcou como tendo sido efetivamente abordadas na formação. |
| Observacoes | Texto (Longo) | Notas e observações sobre a turma. |

### **3.4. Tabela: Sessoes**

**Propósito:** Regista cada sessão de formação (aula) individual que compõe uma Turma.

| Nome do Campo | Tipo de Dados Sugerido | Descrição / Propósito |
| :---- | :---- | :---- |
| ID\_Sessao | Identificador Único (PK) | Chave primária única para cada sessão. |
| Nome | Texto (Curto) | Título da sessão (ex: "Sessão 1: Introdução à Segurança Digital"). |
| ID\_Turma | Relação (FK) | Referência à Turma a que esta sessão pertence. |
| ID\_Formadores\_Sessao | Relação Múltipla (FK) | Referência aos formadores específicos desta sessão. Se nulo, herda os formadores da Turma. Permite registar substituições. |
| Data\_Sessao | Data | Data específica da sessão. |
| Hora\_Inicio | Hora | Hora de início da sessão. |
| Hora\_Fim | Hora | Hora de fim da sessão. |
| Duracao\_Horas | Numérico (Decimal) | Duração da sessão em horas (ex: 2.5 para 2h30m). |
| Sumario | Texto (Longo) | Tópicos e sumário dos conteúdos a abordar na sessão. |
| **URL\_Recursos\_Pedagogicos** | **URL / Hiperligação** | **(Novo)** Link para materiais de apoio específicos desta sessão (ex: slides, vídeos, artigos). |

### **3.5. Tabela: Matriculas**

**Propósito:** Funciona como a tabela de ligação que representa o percurso de um Inscrito numa Turma, incluindo os seus resultados de avaliação.

| Nome do Campo | Tipo de Dados Sugerido | Descrição / Propósito |
| :---- | :---- | :---- |
| ID\_Matricula | Identificador Único (PK) | Chave primária única para cada matrícula. |
| ID\_Inscrito | Relação (FK) | Referência ao participante na tabela Inscritos. |
| ID\_Turma | Relação (FK) | Referência à turma na tabela Turmas. |
| ID\_Estado\_Matricula | Relação (FK) | Referência ao estado da matrícula na tabela Tipos\_Estado\_Matricula. |
| ID\_Nivel\_Experiencia | Relação (FK) | Referência ao nível de experiência na tabela Tipos\_Nivel\_Experiencia. |
| Respostas\_Desafio\_Final | JSON / Texto (Longo) | Uma cópia das respostas do formando ao desafio digital final, para fins de auditoria e consulta. |
| Classificacao\_Desafio\_Final | Texto (Curto) | A classificação obtida no desafio digital (ex: "Aprovado", "20", "Apto"). |
| Classificacao\_Final | Texto (Curto) | A classificação final atribuída ao formando na conclusão da sua participação na turma. |
| Total\_Horas\_Assistidas | Numérico (Decimal) | O total de horas de formação frequentadas pelo formando, calculado a partir da soma das presenças. |
| Avaliacao\_Do\_Curso | Numérico (Inteiro) | Avaliação do curso pelo participante (ex: 1 a 5), preenchida no final. |
| Comentarios\_Avaliacao | Texto (Longo) | Comentários de feedback do participante sobre o curso. |
| Data\_De\_Inscricao | Data e Hora | Data e hora em que a matrícula foi efetuada. |
| Data\_De\_Conclusao | Data e Hora | Data e hora em que o estado foi alterado para "Concluído com Sucesso". |
| **URL\_Certificado\_Conclusao** | **URL / Hiperligação** | **(Novo)** Link para o certificado de conclusão da formação (PDF ou outro formato), a ser disponibilizado no futuro portal do formando. |

### **3.6. Tabela: Presencas**

**Propósito:** Registo granular da presença de um participante (através da sua Matricula) em cada Sessao.

| Nome do Campo | Tipo de Dados Sugerido | Descrição / Propósito |
| :---- | :---- | :---- |
| ID\_Presenca | Identificador Único (PK) | Chave primária única para cada registo de presença. |
| ID\_Matricula | Relação (FK) | Referência à matrícula do participante na tabela Matriculas. |
| ID\_Sessao | Relação (FK) | Referência à sessão na tabela Sessoes. |
| ID\_Estado\_Presenca | Relação (FK) | Referência ao estado da presença na tabela Tipos\_Estado\_Presenca. |
| Horas\_Assistidas | Numérico (Decimal) | Permite registar presenças parciais (ex: 1.5 horas numa sessão de 3 horas). |
| ID\_Metodo\_Registo | Relação (FK) | Referência ao método de registo na tabela Tipos\_Metodo\_Registo. |
| Data\_Registo | Data e Hora | Data e hora em que a presença foi efetivamente registada. |

### **3.7. Tabela: Badges\_Atribuidos**

**Propósito:** O "Passaporte Digital" de cada participante. Regista cada badge que um Inscrito conquista.

| Nome do Campo | Tipo de Dados Sugerido | Descrição / Propósito |
| :---- | :---- | :---- |
| ID\_Badge\_Atribuido | Identificador Único (PK) | Chave primária única para cada badge emitido. |
| ID\_Inscrito | Relação (FK) | Referência ao participante na tabela Inscritos. |
| ID\_Competencia | Relação (FK) | Referência à competência certificada na tabela Competencias. |
| ID\_Matricula\_Origem | Relação (FK) | Referência à matrícula na tabela Matriculas que originou a emissão deste badge. |
| Data\_De\_Emissao | Data e Hora | Data e hora exatas da emissão do badge. |
| URL\_Certificado | URL / Hiperligação | Link para o certificado digital ou página do Open Badge. |

### **3.8. Tabela: Equipamentos\_Alocados**

**Propósito:** Regista a alocação de um ou mais equipamentos de um determinado tipo a uma turma específica, controlando o seu ciclo de vida (entrega e recolha).

| Nome do Campo | Tipo de Dados Sugerido | Descrição / Propósito |
| :---- | :---- | :---- |
| ID\_Alocacao | Identificador Único (PK) | Chave primária única para cada alocação. |
| ID\_Turma | Relação (FK) | Referência à Turma que está a utilizar o equipamento. |
| ID\_Tipo\_Equipamento | Relação (FK) | Referência ao tipo de equipamento na tabela Tipos\_Equipamento. |
| Quantidade | Numérico (Inteiro) | Número de unidades do equipamento alocadas a esta turma. |
| Data\_Entrega | Data e Hora | Data e hora em que o equipamento foi entregue ao formador/local. |
| Data\_Recolha\_Prevista | Data | Data prevista para a devolução do equipamento. |
| Data\_Recolha\_Efetiva | Data e Hora | Data e hora em que o equipamento foi efetivamente devolvido. |
| ID\_Estado\_Alocacao | Relação (FK) | Referência ao estado da alocação na tabela Tipos\_Estado\_Alocacao. |
| Observacoes | Texto (Longo) | Notas sobre o estado do equipamento na entrega ou recolha. |

### **3.9. Tabela: Dossier\_Submissoes**

**Propósito:** Rastreia a conclusão do Dossier Técnico Pedagógico para cada turma, registando a submissão dos relatórios de satisfação por parte de cada interveniente (coordenador e formadores).

| Nome do Campo | Tipo de Dados Sugerido | Descrição / Propósito |
| :---- | :---- | :---- |
| ID\_Submissao | Identificador Único (PK) | Chave primária única para cada registo de submissão. |
| ID\_Turma | Relação (FK) | Referência à Turma a que este registo diz respeito. |
| ID\_Utilizador | Relação (FK) | Relação (FK) para a tabela Utilizadores, identificando quem submeteu o relatório. |
| ID\_Funcao\_Turma | Relação (FK) | Referência à função do utilizador na tabela Tipos\_Funcao\_Turma. |
| ID\_Estado\_Submissao | Relação (FK) | Referência ao estado da submissão na tabela Tipos\_Estado\_Submissao. |
| Data\_Submissao | Data e Hora | Data e hora em que o relatório foi efetivamente submetido. |
| URL\_Relatorio\_Satisfacao | URL / Hiperligação | Link para o relatório de avaliação de satisfação submetido pelo utilizador. |

### **3.10. Tabela: Registos\_De\_Acoes**

**Propósito:** O registo de auditoria imutável para todas as ações importantes realizadas no sistema.

| Nome do Campo | Tipo de Dados Sugerido | Descrição / Propósito |
| :---- | :---- | :---- |
| ID\_Acao | Identificador Único (PK) | Chave primária única para cada ação registada. |
| ID\_Tipo\_De\_Acao | Relação (FK) | Referência ao tipo de ação na tabela Tipos\_De\_Acao. |
| ID\_Autor\_Da\_Acao | Relação (FK) | Relação (FK) para a tabela Utilizadores, identificando o autor da ação. |
| ID\_Contexto | Relação (FK) | Referência polimórfica ao registo principal afetado (ex: um ID de Inscritos ou Matriculas). |
| Detalhes | JSON / Texto (Longo) | Campo para guardar informação contextual extra (ex: o JSON de uma submissão de formulário). |
| Data\_Da\_Acao | Data e Hora | Data e hora exatas em que a ação ocorreu. |

### **3.11. Tabela: Tipos\_De\_Acao**

**Propósito:** Lista mestre com os tipos de eventos que podem ser registados no sistema para auditoria.

| Nome do Campo | Tipo de Dados Sugerido | Descrição / Propósito |
| :---- | :---- | :---- |
| ID\_Tipo\_De\_Acao | Identificador Único (PK) | Chave primária única para cada tipo de ação. |
| Nome | Texto (Curto) | Nome descritivo da ação. |
| Palavra\_Chave | Texto (Curto, Único) | Palavra-chave para uso interno no código. |
| Descricao | Texto (Longo) | Explicação detalhada do propósito da ação no sistema. |

**Valores Sugeridos para a Tabela Tipos\_De\_Acao:**

| Nome | Palavra\_Chave | Descrição |
| :---- | :---- | :---- |
| Pré-inscrição Recebida | PRE\_INSCRICAO\_RECEBIDA | Um novo formulário de interesse foi submetido. |
| Inscrição Criada | INSCRICAO\_CRIADA | Um perfil de inscrito foi criado no sistema. |
| Inscrição Atualizada | INSCRICAO\_ATUALIZADA | Os dados de um inscrito foram alterados. |
| Matrícula Criada | MATRICULA\_CRIADA | Um inscrito foi matriculado numa turma. |
| Estado da Matrícula Alterado | MATRICULA\_ESTADO\_ALTERADO | O estado de uma matrícula foi alterado (ex: de "Inscrito" para "A frequentar"). |
| Convocatória Enviada | CONVOCATORIA\_ENVIADA | Uma comunicação (email) de convocatória foi enviada para uma turma. |
| Presenças Submetidas | PRESENCAS\_SUBMETIDAS | Um formador submeteu o registo de presenças para uma sessão. |
| Desafio Final Submetido | DESAFIO\_FINAL\_SUBMETIDO | Um formando submeteu as suas respostas ao desafio digital final. |
| Avaliação de Satisfação Submetida | AVALIACAO\_SATISFACAO\_SUBMETIDA | Um coordenador ou formador submeteu o seu relatório de avaliação de satisfação. |
| Início de Conquista de Badge | BADGE\_CLAIM\_STARTED | O formando iniciou o processo de obtenção de um badge (ex: clicou no link). |
| Badge Emitido | BADGE\_EMITIDO | Um badge foi oficialmente atribuído a um formando. |
| Certificado Emitido | CERTIFICADO\_EMITIDO | Um certificado de participação ou conclusão foi gerado. |
| Relatório Gerado | RELATORIO\_GERADO | Um utilizador gerou e/ou exportou um relatório do sistema. |

## **3.A. Novas Entidades Operacionais**

### **3.A.1. Tabela: Turma\_Competencias\_Lecionadas**

**Justificação da Criação:** Esta tabela de ligação é necessária para implementar a funcionalidade da "Jornada do Formador" onde ele pode selecionar quais das competências planeadas para um curso foram efetivamente lecionadas naquela turma específica.

| Nome do Campo | Tipo de Dados Sugerido | Descrição / Propósito |
| :---- | :---- | :---- |
| ID\_Turma | Relação (FK) | Referência à Turmas. |
| ID\_Competencia | Relação (FK) | Referência à Competencias. |

### **3.A.2. Tabela: Desafios\_Turma**

**Justificação da Criação:** Esta tabela é o pilar técnico que suporta a "Jornada do Formador" e a "Cerimónia de Finalização" do formando. Ela armazena o "link mágico" único que o formador gera para cada turma, garantindo a segurança e a rastreabilidade do processo de avaliação final.

| Nome do Campo | Tipo de Dados Sugerido | Descrição / Propósito |
| :---- | :---- | :---- |
| ID\_Desafio\_Turma | Identificador Único (PK) | Chave primária única para cada desafio gerado. |
| ID\_Turma | Relação (FK) | Referência à Turmas para a qual este desafio foi criado. |
| ID\_Utilizador\_Criador | Relação (FK) | Relação (FK) para a tabela Utilizadores, identificando o formador que gerou o link do desafio. |
| Token\_Acesso | Texto (Curto, Único) | Um código único e não sequencial (ex: UUID) que torna o URL do desafio impossível de adivinhar. |
| URL\_Gerado | URL / Hiperligação | O "link mágico" completo que é partilhado com os formandos. |
| Data\_Criacao | Data e Hora | Data e hora exatas em que o link foi gerado. |
| Data\_Expiracao | Data e Hora | (Opcional) Data a partir da qual o link deixa de ser válido. |
| Estado | Lista de Escolha | Estado do link (ex: "Ativo", "Expirado", "Fechado"). |
