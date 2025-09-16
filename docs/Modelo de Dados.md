# **Modelo de Dados Consolidado: Passaporte Competências Digitais**

**Versão:** 4.0 (UX-Driven)

**Data:** 4 de agosto de 2025

**Autor:** HT

## **1. Introdução**

Este documento detalha o modelo de dados unificado e agnóstico para a aplicação de gestão "Passaporte Competências Digitais". O seu propósito é servir como a única fonte de verdade para a estrutura de dados, independentemente da plataforma tecnológica escolhida para a sua implementação.

**Evolução (v4.0):** Esta versão foi enriquecida com base num mapeamento detalhado da **Experiência do Utilizador (UX)**. As alterações introduzidas visam suportar diretamente as jornadas específicas do Coordenador, Técnico, Formador e Formando, acrescentando a granularidade necessária para implementar funcionalidades mais ricas, como a gestão de recursos pedagógicos por sessão, o controlo de competências efetivamente lecionadas e a inovadora "Cerimónia de Finalização" do curso.

## **2. Entidades de Catálogo e Configuração**

Estas entidades contêm os dados de referência que raramente mudam e servem de base para o funcionamento do programa.

### **2.1. Tabela: Programas**

**Propósito:** Catálogo dos diferentes programas ou iniciativas de formação que a organização gere. Esta é a entidade de topo que agrupa os cursos.

| Nome do Campo | Tipo de Dados Sugerido | Descrição / Propósito |
| :---- | :---- | :---- |
| ID_PROGRAMA | NUMBER (PK) | Chave primária única para cada programa. |
| NOME | VARCHAR2(255) (Unique, Not Null) | O nome oficial do programa (ex: "Passaporte Competências Digitais"). |
| DESCRICAO | CLOB | Uma breve descrição dos objetivos e público-alvo do programa. |

### **2.2. Tabela: Competencias**

**Propósito:** Armazena o catálogo mestre das competências digitais abrangidas pelo programa, alinhadas com o modelo DigComp.

| Nome do Campo | Tipo de Dados Sugerido | Descrição / Propósito |
| :---- | :---- | :---- |
| ID_COMPETENCIA | NUMBER (PK) | Chave primária única para cada competência. |
| NOME | VARCHAR2(255) (Not Null) | O nome oficial da competência (ex: "Cidadania Digital"). |
| DESCRICAO | CLOB | Descrição detalhada da competência. |
| ID_AREA_COMPETENCIA | NUMBER (FK) | Referência à área da competência na tabela Tipos_Area_Competencia. |
| ID_NIVEL_PROFICIENCIA | NUMBER (FK) | Referência ao nível de proficiência na tabela Tipos_Nivel_Proficiencia. |
| URL_MEDALHA_DIGITAL | VARCHAR2(2000) | O link único para a conquista da medalha digital associada a esta competência. |
| URL_ICONE_BADGE | VARCHAR2(2000) | O link para o ficheiro de imagem (.svg, .png) do ícone visual do badge. |

### **2.3. Tabela: Cursos**

**Propósito:** O catálogo completo de todos os cursos de formação disponíveis, cada um associado a um programa específico.

| Nome do Campo | Tipo de Dados Sugerido | Descrição / Propósito |
| :---- | :---- | :---- |
| ID_CURSO | NUMBER (PK) | Chave primária única para cada curso. |
| ID_PROGRAMA | NUMBER (FK) | Referência ao programa ao qual o curso pertence na tabela Programas. |
| NOME | VARCHAR2(255) (Not Null) | O nome oficial do curso. |
| ID_ESTADO_CURSO | NUMBER (FK) | Referência ao estado do curso na tabela Tipos_Estado_Curso. |
| CARGA_HORARIA | NUMBER | Duração total do curso em horas. |
| COMPETENCIAS_ASSOCIADAS | VARCHAR2(4000) | Lista de IDs da tabela Competencias, separados por dois pontos (ex: '1:3:7'), para suportar seletores múltiplos (shuttles) no APEX. |
| MODALIDADE_FORMACAO | VARCHAR2(255) | A modalidade geral da formação (ex: "Formação contínua"). |
| FORMA_ORGANIZACAO | VARCHAR2(255) | O formato de entrega do curso (ex: "Presencial", "Online (síncrona)", "Híbrido"). |
| PUBLICO_ALVO | CLOB | Descrição detalhada dos destinatários preferenciais do curso. |
| OBJETIVOS_GERAIS | CLOB | Os objetivos de aprendizagem gerais do curso. |
| OBJETIVOS_ESPECIFICOS | CLOB | Os objetivos de aprendizagem detalhados e específicos. |
| CONTEUDOS_PROGRAMATICOS | CLOB | A lista de tópicos e conteúdos abordados no curso. |
| METODOLOGIA_AVALIACAO | CLOB | Descrição dos métodos e critérios de avaliação utilizados no curso. |
| URL_MANUAL_DIGITAL | VARCHAR2(2000) | Link para o manual digital ou material de apoio principal do curso. |

### **2.4. Tabela: Tipos_De_Qualificacao**

**Propósito:** Tabela de suporte com os níveis de habilitações literárias e a sua correspondência com o Quadro Europeu de Qualificações (QEQ).

| Nome do Campo | Tipo de Dados Sugerido | Descrição / Propósito |
| :---- | :---- | :---- |
| ID_QUALIFICACAO | NUMBER (PK) | Chave primária única para cada tipo de qualificação. |
| NOME | VARCHAR2(255) (Not Null) | O nome da qualificação (ex: "Ensino Secundário", "Mestrado"). |
| NIVEL_QEQ | NUMBER(2,0) | O nível correspondente no Quadro Europeu de Qualificações (1 a 8). |
| DESCRICAO | CLOB | Descrição mais detalhada da qualificação, se necessário. |

### **2.5. Tabela: Modelos_De_Comunicacao**

**Propósito:** Armazena os templates para comunicações (ex: emails), permitindo a sua edição sem necessidade de alterar o código da aplicação.

| Nome do Campo | Tipo de Dados Sugerido | Descrição / Propósito |
| :---- | :---- | :---- |
| ID_MODELO | NUMBER (PK) | Chave primária única para cada modelo. |
| NOME | VARCHAR2(255) (Not Null) | Nome interno para identificar o modelo (ex: "Email de Boas-Vindas"). |
| ASSUNTO | VARCHAR2(1000) | O assunto pré-preenchido do email ou comunicação. |
| CORPO | CLOB | O corpo da mensagem, com suporte para formatação e placeholders (ex: {NomeInscrito}, {NomeCurso}). |
| ID_TIPO_NOTIFICACAO | NUMBER (FK) | Referência ao tipo de notificação na tabela Tipos_Notificacao. |
| EVENTO_GATILHO | VARCHAR2(255) | Descrição do evento que despoleta a notificação (ex: "Inscrição confirmada"). |

### **2.6. Tabela: Configuracoes_Formulario**

**Propósito:** Armazena os mapeamentos técnicos entre os campos da base de dados e os campos de formulários externos (Google Forms, Microsoft Forms, etc.), permitindo a geração de links pré-preenchidos.

| Nome do Campo | Tipo de Dados Sugerido | Descrição / Propósito |
| :---- | :---- | :---- |
| ID_CONFIGURACAO | NUMBER (PK) | Chave primária da configuração. |
| NOME | VARCHAR2(255) (Not Null) | Um nome para esta configuração (ex: "Desafio Digital Final V1", "Avaliação de Curso Padrão"). |
| TIPO_FORMULARIO | VARCHAR2(100) | O tipo de formulário (ex: "Google Form", "Microsoft Form"). |
| ID_FORMULARIO_EXTERNO | VARCHAR2(255) | O ID do formulário (ex: o GOOGLE_FORM_ID). |
| URL_BASE | VARCHAR2(2000) | O link base do formulário, sem campos pré-preenchidos. |
| MAPEAMENTO_CAMPOS | CLOB (JSON) | Armazena a "tradução" dos campos da base de dados para os campos do formulário. Ex: {"nome_curso": "entry.123", "nome_formador_1": "entry.456"}. |

### **2.7. Tabela: Tipos_Equipamento**

**Propósito:** Catálogo de todos os tipos de equipamentos (webcams, kits de robótica, etc.) que podem ser alocados às ações de formação.

| Nome do Campo | Tipo de Dados Sugerido | Descrição / Propósito |
| :---- | :---- | :---- |
| ID_TIPO_EQUIPAMENTO | NUMBER (PK) | Chave primária única para cada tipo de equipamento. |
| NOME | VARCHAR2(255) (Unique, Not Null) | Nome ou modelo do equipamento (ex: "Webcam Logitech C920", "Kit Micro:bit V2"). |
| DESCRICAO | CLOB | Descrição detalhada do equipamento e das suas características. |
| ID_CATEGORIA_EQUIPAMENTO | NUMBER (FK) | Referência à categoria do equipamento na tabela Tipos_Categoria_Equipamento. |

### **2.8. Tabela: Utilizadores**

**Propósito:** A tabela central para todos os utilizadores internos do sistema (Coordenadores, Técnicos, Formadores). Esta tabela é a fonte de verdade para a autenticação e para o modelo de segurança baseado em funções.

| Nome do Campo | Tipo de Dados Sugerido | Descrição / Propósito |
| :--- | :--- | :--- |
| ID_UTILIZADOR | NUMBER (PK) | Chave primária única para cada utilizador. |
| NOME_COMPLETO | VARCHAR2(255) (Not Null) | O nome completo do utilizador. |
| EMAIL | VARCHAR2(255) (Unique, Not Null) | O email do utilizador, usado para login e como chave de negócio única. |
| FUNCAO | VARCHAR2(100) | A função do utilizador no sistema (ex: 'COORDENADOR', 'TECNICO', 'FORMADOR'). Controla as permissões. |
| ATIVO | VARCHAR2(1) (Default: 'S') | Indica se a conta do utilizador está ativa. Contas inativas não podem fazer login. |
| DATA_CRIACAO | TIMESTAMP WITH TIME ZONE | Data e hora em que o registo do utilizador foi criado. |

### **2.A. Novas Entidades de Lookup (Listas de Opções Dinâmicas)**

**Propósito:** Este novo conjunto de tabelas armazena os valores para as listas de opções da aplicação. Esta arquitetura permite a gestão centralizada e dinâmica destas opções pela equipa, sem necessidade de alterações no código. Cada tabela segue uma estrutura padrão: ID, Nome (o valor exibido) e Ordem_Exibicao.

| Nome da Tabela | Propósito |
| :---- | :---- |
| **Tipos_Area_Competencia** | Armazena as áreas do modelo DigComp (ex: "Segurança"). |
| **Tipos_Nivel_Proficiencia** | Armazena os níveis de proficiência (ex: "Introdução"). |
| **Tipos_Estado_Curso** | Armazena os estados de um curso no catálogo (ex: "Ativo"). |
| **Tipos_Notificacao** | Armazena os tipos de notificação (ex: "Automática"). |
| **Tipos_Categoria_Equipamento** | Armazena as categorias de equipamento (ex: "Hardware"). |
| **Tipos_Estado_Pre_Inscricao** | Armazena os estados do funil de pré-inscrição (ex: "Nova"). |
| **Tipos_Genero** | Armazena as opções de género (ex: "Feminino"). |
| **Tipos_Doc_Identificacao** | Armazena os tipos de documento de identificação (ex: "Cartão de Cidadão"). |
| **Tipos_Situacao_Profissional** | Armazena as situações profissionais dos inscritos (ex: "Desempregado"). |
| **Tipos_Estado_Geral_Inscrito** | Armazena o estado geral de um participante no programa (ex: "Ativo"). |
| **Tipos_Estado_Turma** | Armazena os estados de uma turma (ex: "Em Curso"). |
| **Tipos_Estado_Dossier** | Armazena os estados do dossier pedagógico (ex: "Pendente"). |
| **Tipos_Estado_Matricula** | Armazena os estados de uma matrícula (ex: "A frequentar"). |
| **Tipos_Nivel_Experiencia** | Armazena os níveis de experiência auto-reportados (ex: "Iniciante"). |
| **Tipos_Estado_Presenca** | Armazena os estados de uma presença numa sessão (ex: "Presente"). |
| **Tipos_Metodo_Registo** | Armazena os métodos de registo de presença (ex: "Manual"). |
| **Tipos_Estado_Alocacao** | Armazena os estados de uma alocação de equipamento (ex: "Em Uso"). |
| **Tipos_Funcao_Turma** | Armazena as funções de um utilizador numa turma (ex: "Formador"). |
| **Tipos_Estado_Submissao** | Armazena os estados de submissão de um relatório (ex: "Submetido"). |

## **3. Entidades Operacionais**

Estas entidades registam a atividade diária do programa e estão em constante atualização.

### **3.1. Tabela: Pre_Inscricoes**

**Propósito:** Armazena os dados brutos de cada manifestação de interesse, servindo como a porta de entrada para o programa.

| Nome do Campo | Tipo de Dados Sugerido | Descrição / Propósito |
| :---- | :---- | :---- |
| ID_PRE_INSCRICAO | NUMBER (PK) | Chave primária única para cada pré-inscrição. |
| NOME_COMPLETO | VARCHAR2(255) | Nome completo do interessado. |
| EMAIL | VARCHAR2(255) | Email de contacto do interessado. |
| CONTACTO_TELEFONICO | VARCHAR2(50) | Número de telefone de contacto. |
| NIF | NUMBER | Número de Identificação Fiscal do interessado. |
| DATA_NASCIMENTO | DATE | Data de nascimento do interessado. |
| CONSENTIMENTO_DADOS | VARCHAR2(1) (Default: 'N') | Registo do consentimento da política de privacidade. |
| INTERESSES | CLOB (JSON) | Armazena os dados estruturados (cursos, locais, experiência) da submissão do formulário. |
| DATA_SUBMISSAO | TIMESTAMP WITH TIME ZONE | Data e hora exatas da submissão do formulário (preenchido automaticamente). |
| ID_ESTADO_PRE_INSCRICAO | NUMBER (FK) | Referência ao estado da pré-inscrição na tabela Tipos_Estado_Pre_Inscricao. |

### **3.2. Tabela: Inscritos (anteriormente Perfis)**

**Propósito:** A tabela mestre para cada indivíduo, contendo o seu perfil demográfico e de contacto. É o registo central e único de uma pessoa no programa.

| Nome do Campo | Tipo de Dados Sugerido | Descrição / Propósito |
| :---- | :---- | :---- |
| ID_INSCRITO | NUMBER (PK) | Chave primária única para cada participante. |
| NOME_COMPLETO | VARCHAR2(255) (Not Null) | Nome completo oficial do participante. |
| EMAIL | VARCHAR2(255) (Unique, Not Null) | Email principal do participante, usado como identificador único. |
| CONTACTO_TELEFONICO | VARCHAR2(50) | Número de telefone principal. |
| NIF | NUMBER (Unique) | NIF do participante, usado como identificador único secundário. |
| DATA_NASCIMENTO | DATE | Data de nascimento. |
| ID_GENERO | NUMBER (FK) | Referência ao género do participante na tabela Tipos_Genero. |
| NATURALIDADE | VARCHAR2(255) | Local de nascimento. |
| NACIONALIDADE | VARCHAR2(255) | Nacionalidade. |
| ID_TIPO_DOC_IDENTIFICACAO | NUMBER (FK) | Referência ao tipo de documento na tabela Tipos_Doc_Identificacao. |
| DOC_IDENTIFICACAO_NUM | VARCHAR2(100) | Número do documento de identificação. |
| VALIDADE_DOC_IDENTIFICACAO | DATE | Data de validade do documento. |
| MORADA | VARCHAR2(1000) | Morada de residência. |
| CODIGO_POSTAL | VARCHAR2(50) | Código Postal de residência. |
| LOCALIDADE_CODIGO_POSTAL | VARCHAR2(255) | Localidade de residência. |
| ID_SITUACAO_PROFISSIONAL | NUMBER (FK) | Referência à situação profissional na tabela Tipos_Situacao_Profissional. |
| ID_QUALIFICACAO | NUMBER (FK) | Referência ao nível de habilitações literárias na tabela Tipos_De_Qualificacao. |
| CONSENTIMENTO_RGPD | VARCHAR2(1) (Default: 'N') | Registo do consentimento explícito do participante para o tratamento de dados, de acordo com o RGPD. |
| ID_ESTADO_GERAL_INSCRITO | NUMBER (FK) | Referência ao estado geral do participante na tabela Tipos_Estado_Geral_Inscrito. |
| INTERESSES_INICIAIS | CLOB | Armazena os interesses originais da primeira pré-inscrição. |
| ORIGEM_INSCRICAO | VARCHAR2(255) | Canal através do qual a inscrição foi feita (ex: "Formulário Online", "Sessão Presencial"). |
| OBSERVACOES | CLOB | Campo para notas e observações gerais sobre o inscrito. |
| DATA_CRIACAO | TIMESTAMP WITH TIME ZONE | Data e hora em que o registo do inscrito foi criado. |

### **3.3. Tabela: Turmas**

**Propósito:** Regista cada instância de um curso para um grupo específico de formandos, com a sua informação logística.

| Nome do Campo | Tipo de Dados Sugerido | Descrição / Propósito |
| :---- | :---- | :---- |
| ID_TURMA | NUMBER (PK) | Chave primária única para cada turma. |
| NOME | VARCHAR2(255) (Not Null) | Nome ou código da turma (ex: "NIS-T5-Lumiar"). |
| ID_CURSO | NUMBER (FK) | Referência ao curso correspondente na tabela Cursos. |
| FORMADORES | VARCHAR2(4000) | Lista de IDs da tabela Utilizadores, separados por dois pontos (ex: '101:102'), para ser usado por componentes APEX como shuttles. |
| ID_COORDENADOR | NUMBER (FK) | Relação (FK) para a tabela Utilizadores, identificando o coordenador responsável pela turma. |
| NUMERO_DA_TURMA | VARCHAR2(100) | Código interno ou número sequencial da turma (ex: "Ação nº 1"). |
| ID_ESTADO_TURMA | NUMBER (FK) | Referência ao estado da turma na tabela Tipos_Estado_Turma. |
| ID_ESTADO_DOSSIER | NUMBER (FK) | Referência ao estado do dossier na tabela Tipos_Estado_Dossier. |
| DATA_INICIO | DATE | Data de início da turma. |
| DATA_FIM | DATE | Data de fim da turma. |
| LOCAL_FORMACAO | VARCHAR2(255) | Local principal onde decorre a formação. |
| HORARIO | VARCHAR2(255) | Horário principal da turma (ex: "Pós-laboral, 19h-22h"). |
| CALENDARIZACAO_TEXTO | CLOB | Descrição textual do calendário da turma (ex: "27, 28 e 29 de abril de 2020, das 10h00 às 13h00"). |
| ESTRUTURA_SESSOES_TEXTO | CLOB | Descrição sumária da estrutura das sessões (ex: "9 horas, distribuídas por 3 sessões de 3 horas"). |
| VAGAS | NUMBER | Número de vagas disponíveis para a turma. |
| TOTAL_INQUIRIDOS | NUMBER | O número de respostas recebidas no questionário de avaliação. |
| ID_CONFIG_AVALIACAO | NUMBER (FK) | Aponta para a Configuracoes_Formulario a usar para o questionário de avaliação desta turma. |
| ID_CONFIG_DESAFIO_FINAL | NUMBER (FK) | Aponta para a Configuracoes_Formulario a usar para o desafio digital desta turma. |
| COMPETENCIAS_PARA_DESAFIO | VARCHAR2(4000) | Lista de IDs da tabela Competencias, separados por dois pontos (ex: '5:8:12'), que serão testadas no desafio digital desta turma. |
| OBSERVACOES | CLOB | Notas e observações sobre a turma. |

### **3.4. Tabela: Sessoes**

**Propósito:** Regista cada sessão de formação (aula) individual que compõe uma Turma.

| Nome do Campo | Tipo de Dados Sugerido | Descrição / Propósito |
| :---- | :---- | :---- |
| ID_SESSAO | NUMBER (PK) | Chave primária única para cada sessão. |
| NOME | VARCHAR2(255) (Not Null) | Título da sessão (ex: "Sessão 1: Introdução à Segurança Digital"). |
| ID_TURMA | NUMBER (FK) | Referência à Turma a que esta sessão pertence. |
| ID_FORMADORES_SESSAO | VARCHAR2(4000) | Referência aos formadores específicos desta sessão. Se nulo, herda os formadores da Turma. Permite registar substituições. |
| DATA_SESSAO | DATE | Data específica da sessão. |
| HORA_INICIO | VARCHAR2(5) | Hora de início da sessão. |
| HORA_FIM | VARCHAR2(5) | Hora de fim da sessão. |
| DURACAO_HORAS | NUMBER(4,2) | Duração da sessão em horas (ex: 2.5 para 2h30m). |
| SUMARIO | CLOB | Tópicos e sumário dos conteúdos a abordar na sessão. |
| URL_RECURSOS_PEDAGOGICOS | VARCHAR2(2000) | Link para materiais de apoio específicos desta sessão (ex: slides, vídeos, artigos). |

### **3.5. Tabela: Matriculas**

**Propósito:** Funciona como a tabela de ligação que representa o percurso de um Inscrito numa Turma, incluindo os seus resultados de avaliação.

| Nome do Campo | Tipo de Dados Sugerido | Descrição / Propósito |
| :---- | :---- | :---- |
| ID_MATRICULA | NUMBER (PK) | Chave primária única para cada matrícula. |
| ID_INSCRITO | NUMBER (FK) | Referência ao participante na tabela Inscritos. |
| ID_TURMA | NUMBER (FK) | Referência à turma na tabela Turmas. |
| ID_ESTADO_MATRICULA | NUMBER (FK) | Referência ao estado da matrícula na tabela Tipos_Estado_Matricula. |
| ID_NIVEL_EXPERIENCIA | NUMBER (FK) | Referência ao nível de experiência na tabela Tipos_Nivel_Experiencia. |
| RESPOSTAS_DESAFIO_FINAL | CLOB | Uma cópia das respostas do formando ao desafio digital final, para fins de auditoria e consulta. |
| CLASSIFICACAO_DESAFIO_FINAL | VARCHAR2(255) | A classificação obtida no desafio digital (ex: "Aprovado", "20", "Apto"). |
| CLASSIFICACAO_FINAL | VARCHAR2(255) | A classificação final atribuída ao formando na conclusão da sua participação na turma. |
| TOTAL_HORAS_ASSISTIDAS | NUMBER(5,2) | O total de horas de formação frequentadas pelo formando, calculado a partir da soma das presenças. |
| AVALIACAO_DO_CURSO | NUMBER(2,0) | Avaliação do curso pelo participante (ex: 1 a 5), preenchida no final. |
| COMENTARIOS_AVALIACAO | CLOB | Comentários de feedback do participante sobre o curso. |
| DATA_DE_INSCRICAO | TIMESTAMP WITH TIME ZONE | Data e hora em que a matrícula foi efetuada. |
| DATA_DE_CONCLUSAO | TIMESTAMP WITH TIME ZONE | Data e hora em que o estado foi alterado para "Concluído com Sucesso". |
| URL_CERTIFICADO_CONCLUSAO | VARCHAR2(2000) | Link para o certificado de conclusão da formação (PDF ou outro formato), a ser disponibilizado no futuro portal do formando. |

### **3.6. Tabela: Presencas**

**Propósito:** Registo granular da presença de um participante (através da sua Matricula) em cada Sessao.

| Nome do Campo | Tipo de Dados Sugerido | Descrição / Propósito |
| :---- | :---- | :---- |
| ID_PRESENCA | NUMBER (PK) | Chave primária única para cada registo de presença. |
| ID_MATRICULA | NUMBER (FK) | Referência à matrícula do participante na tabela Matriculas. |
| ID_SESSAO | NUMBER (FK) | Referência à sessão na tabela Sessoes. |
| ID_ESTADO_PRESENCA | NUMBER (FK) | Referência ao estado da presença na tabela Tipos_Estado_Presenca. |
| HORAS_ASSISTIDAS | NUMBER(4,2) | Permite registar presenças parciais (ex: 1.5 horas numa sessão de 3 horas). |
| ID_METODO_REGISTO | NUMBER (FK) | Referência ao método de registo na tabela Tipos_Metodo_Registo. |
| DATA_REGISTO | TIMESTAMP WITH TIME ZONE | Data e hora em que a presença foi efetivamente registada. |

### **3.7. Tabela: Badges_Atribuidos**

**Propósito:** O "Passaporte Digital" de cada participante. Regista cada badge que um Inscrito conquista.

| Nome do Campo | Tipo de Dados Sugerido | Descrição / Propósito |
| :---- | :---- | :---- |
| ID_BADGE_ATRIBUIDO | NUMBER (PK) | Chave primária única para cada badge emitido. |
| ID_INSCRITO | NUMBER (FK) | Referência ao participante na tabela Inscritos. |
| ID_COMPETENCIA | NUMBER (FK) | Referência à competência certificada na tabela Competencias. |
| ID_MATRICULA_ORIGEM | NUMBER (FK) | Referência à matrícula na tabela Matriculas que originou a emissão deste badge. |
| DATA_DE_EMISSAO | TIMESTAMP WITH TIME ZONE | Data e hora exatas da emissão do badge. |
| URL_CERTIFICADO | VARCHAR2(2000) | Link para o certificado digital ou página do Open Badge. |

### **3.8. Tabela: Equipamentos_Alocados**

**Propósito:** Regista a alocação de um ou mais equipamentos de um determinado tipo a uma turma específica, controlando o seu ciclo de vida (entrega e recolha).

| Nome do Campo | Tipo de Dados Sugerido | Descrição / Propósito |
| :---- | :---- | :---- |
| ID_ALOCACAO | NUMBER (PK) | Chave primária única para cada alocação. |
| ID_TURMA | NUMBER (FK) | Referência à Turma que está a utilizar o equipamento. |
| ID_TIPO_EQUIPAMENTO | NUMBER (FK) | Referência ao tipo de equipamento na tabela Tipos_Equipamento. |
| QUANTIDADE | NUMBER | Número de unidades do equipamento alocadas a esta turma. |
| DATA_ENTREGA | TIMESTAMP WITH TIME ZONE | Data e hora em que o equipamento foi entregue ao formador/local. |
| DATA_RECOLHA_PREVISTA | DATE | Data prevista para a devolução do equipamento. |
| DATA_RECOLHA_EFETIVA | TIMESTAMP WITH TIME ZONE | Data e hora em que o equipamento foi efetivamente devolvido. |
| ID_ESTADO_ALOCACAO | NUMBER (FK) | Referência ao estado da alocação na tabela Tipos_Estado_Alocacao. |
| OBSERVACOES | CLOB | Notas sobre o estado do equipamento na entrega ou recolha. |

### **3.9. Tabela: Dossier_Submissoes**

**Propósito:** Rastreia a conclusão do Dossier Técnico Pedagógico para cada turma, registando a submissão dos relatórios de satisfação por parte de cada interveniente (coordenador e formadores).

| Nome do Campo | Tipo de Dados Sugerido | Descrição / Propósito |
| :---- | :---- | :---- |
| ID_SUBMISSAO | NUMBER (PK) | Chave primária única para cada registo de submissão. |
| ID_TURMA | NUMBER (FK) | Referência à Turma a que este registo diz respeito. |
| ID_UTILIZADOR | NUMBER (FK) | Relação (FK) para a tabela Utilizadores, identificando quem submeteu o relatório. |
| ID_FUNCAO_TURMA | NUMBER (FK) | Referência à função do utilizador na tabela Tipos_Funcao_Turma. |
| ID_ESTADO_SUBMISSAO | NUMBER (FK) | Referência ao estado da submissão na tabela Tipos_Estado_Submissao. |
| DATA_SUBMISSAO | TIMESTAMP WITH TIME ZONE | Data e hora em que o relatório foi efetivamente submetido. |
| URL_RELATORIO_SATISFACAO | VARCHAR2(2000) | Link para o relatório de avaliação de satisfação submetido pelo utilizador. |

### **3.10. Tabela: Registos_De_Acoes**

**Propósito:** O registo de auditoria imutável para todas as ações importantes realizadas no sistema.

| Nome do Campo | Tipo de Dados Sugerido | Descrição / Propósito |
| :---- | :---- | :---- |
| ID_ACAO | NUMBER (PK) | Chave primária única para cada ação registada. |
| ID_TIPO_DE_ACAO | NUMBER (FK) | Referência ao tipo de ação na tabela Tipos_De_Acao. |
| ID_AUTOR_DA_ACAO | NUMBER (FK) | Relação (FK) para a tabela Utilizadores, identificando o autor da ação. |
| ID_CONTEXTO | NUMBER | Referência polimórfica ao registo principal afetado (ex: um ID de Inscritos ou Matriculas). |
| DETALHES | CLOB | Campo para guardar informação contextual extra (ex: o JSON de uma submissão de formulário). |
| DATA_DA_ACAO | TIMESTAMP WITH TIME ZONE | Data e hora exatas em que a ação ocorreu. |

### **3.11. Tabela: Tipos_De_Acao**

**Propósito:** Lista mestre com os tipos de eventos que podem ser registados no sistema para auditoria.

| Nome do Campo | Tipo de Dados Sugerido | Descrição / Propósito |
| :---- | :---- | :---- |
| ID_TIPO_DE_ACAO | NUMBER (PK) | Chave primária única para cada tipo de ação. |
| NOME | VARCHAR2(255) (Not Null) | Nome descritivo da ação. |
| PALAVRA_CHAVE | VARCHAR2(100) (Unique, Not Null) | Palavra-chave para uso interno no código. |
| DESCRICAO | CLOB | Explicação detalhada do propósito da ação no sistema. |

**Valores Sugeridos para a Tabela Tipos_De_Acao:**

| Nome | Palavra_Chave | Descrição |
| :---- | :---- | :---- |
| Pré-inscrição Recebida | PRE_INSCRICAO_RECEBIDA | Um novo formulário de interesse foi submetido. |
| Inscrição Criada | INSCRICAO_CRIADA | Um perfil de inscrito foi criado no sistema. |
| Inscrição Atualizada | INSCRICAO_ATUALIZADA | Os dados de um inscrito foram alterados. |
| Matrícula Criada | MATRICULA_CRIADA | Um inscrito foi matriculado numa turma. |
| Estado da Matrícula Alterado | MATRICULA_ESTADO_ALTERADO | O estado de uma matrícula foi alterado (ex: de "Inscrito" para "A frequentar"). |
| Convocatória Enviada | CONVOCATORIA_ENVIADA | Uma comunicação (email) de convocatória foi enviada para uma turma. |
| Presenças Submetidas | PRESENCAS_SUBMETIDAS | Um formador submeteu o registo de presenças para uma sessão. |
| Desafio Final Submetido | DESAFIO_FINAL_SUBMETIDO | Um formando submeteu as suas respostas ao desafio digital final. |
| Avaliação de Satisfação Submetida | AVALIACAO_SATISFACAO_SUBMETIDA | Um coordenador ou formador submeteu o seu relatório de avaliação de satisfação. |
| Início de Conquista de Badge | BADGE_CLAIM_STARTED | O formando iniciou o processo de obtenção de um badge (ex: clicou no link). |
| Badge Emitido | BADGE_EMITIDO | Um badge foi oficialmente atribuído a um formando. |
| Certificado Emitido | CERTIFICADO_EMITIDO | Um certificado de participação ou conclusão foi gerado. |
| Relatório Gerado | RELATORIO_GERADO | Um utilizador gerou e/ou exportou um relatório do sistema. |

## **3.A. Novas Entidades Operacionais**

### **3.A.1. Tabela: Turma_Competencias_Lecionadas**

**Justificação da Criação:** Esta tabela de ligação é necessária para implementar a funcionalidade da "Jornada do Formador" onde ele pode selecionar quais das competências planeadas para um curso foram efetivamente lecionadas naquela turma específica.

| Nome do Campo | Tipo de Dados Sugerido | Descrição / Propósito |
| :---- | :---- | :---- |
| ID_TURMA | NUMBER (FK) | Referência à Turmas. |
| ID_COMPETENCIA | NUMBER (FK) | Referência à Competencias. |

### **3.A.2. Tabela: Desafios_Turma**

**Justificação da Criação:** Esta tabela é o pilar técnico que suporta a "Jornada do Formador" e a "Cerimónia de Finalização" do formando. Ela armazena o "link mágico" único que o formador gera para cada turma, garantindo a segurança e a rastreabilidade do processo de avaliação final.

| Nome do Campo | Tipo de Dados Sugerido | Descrição / Propósito |
| :---- | :---- | :---- |
| ID_DESAFIO_TURMA | NUMBER (PK) | Chave primária única para cada desafio gerado. |
| ID_TURMA | NUMBER (FK) | Referência à Turmas para a qual este desafio foi criado. |
| ID_UTILIZADOR_CRIADOR | NUMBER (FK) | Relação (FK) para a tabela Utilizadores, identificando o formador que gerou o link do desafio. |
| TOKEN_ACESSO | VARCHAR2(255) (Unique, Not Null) | Um código único e não sequencial (ex: UUID) que torna o URL do desafio impossível de adivinhar. |
| URL_GERADO | VARCHAR2(2000) | O "link mágico" completo que é partilhado com os formandos. |
| DATA_CRIACAO | TIMESTAMP WITH TIME ZONE | Data e hora exatas em que o link foi gerado. |
| DATA_EXPIRACAO | TIMESTAMP WITH TIME ZONE | (Opcional) Data a partir da qual o link deixa de ser válido. |
| ESTADO | VARCHAR2(50) | Estado do link (ex: "Ativo", "Expirado", "Fechado"). |