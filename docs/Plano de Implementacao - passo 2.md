### **Guia Detalhado (Rev. 2.0): Passo 2 \- A Estrutura Central (Modelo de Dados Completo)**

**Objetivo:** Transformar o "Modelo de Dados v4.0" numa estrutura de base de dados física e íntegra. Este passo é o coração técnico do projeto; é aqui que construímos o "esqueleto" que irá suportar todas as jornadas de utilizador, desde a gestão do Coordenador até à "Cerimónia de Finalização" do Formando.

#### **Visão Geral da Tarefa**

A tarefa consiste em executar um script SQL abrangente no seu Workspace APEX. Este script irá criar todas as tabelas, inserir os dados de base essenciais e estabelecer as relações que garantem a integridade e a lógica do sistema, conforme definido no seu modelo de dados.

#### **Preparação: O Script de Criação (DDL \- Data Definition Language)**

O sucesso deste passo depende de um script SQL bem organizado. O script fornecido está estruturado em quatro partes lógicas para garantir uma execução sem erros.

* **Dica de Boas Práticas:** Copie o script para um editor de texto ou um IDE de base de dados (como o VS Code com extensões Oracle ou o SQL Developer). Não o modifique diretamente no navegador. Guarde este ficheiro no seu sistema de controlo de versões (ex: Git) como `V1__Create_Initial_Schema.sql`. Isto é crucial para o historial do seu projeto.

#### **Execução: Como Correr o Script no Oracle APEX**

1. **Aceda ao seu Workspace APEX** com as credenciais de administrador.  
2. Navegue para **SQL Workshop** \> **SQL Scripts**.  
3. Clique em **Create**.  
4. **Dê um nome ao script** (ex: `01_CRIACAO_ESTRUTURA_BD_V4`) e cole o conteúdo integral do script revisto abaixo.  
5. Clique em **Run** e, na página seguinte, em **Run Now** para iniciar a execução.

#### **Verificação: Confirmar o Sucesso da Operação**

1. **Analisar o Log de Execução:** Na página de resultados, verifique o resumo. Deverá ver "statements processed" com "0 errors". Este é o seu primeiro indicador de sucesso.  
2. **Exploração Detalhada no Object Browser:**  
   * Navegue para **SQL Workshop \> Object Browser**.  
   * **Confirme as Tabelas:** Verifique se todas as tabelas listadas no script, incluindo a nova tabela `UTILIZADORES`, estão presentes.  
   * **Inspecione uma Tabela Chave:** Clique na tabela `MATRICULAS`. Aceda ao separador **Constraints**. Deverá ver as chaves estrangeiras (`fk_matriculas_inscrito`, `fk_matriculas_turma`, etc.) definidas, validando que as relações foram criadas.  
   * **Verifique os Dados Base:** Clique na tabela `TIPOS_ESTADO_TURMA` e aceda ao separador **Data**. Deverá ver os registos que foram inseridos pelo script ('Planeada', 'Em Curso', etc.).

#### **Troubleshooting Comum**

* **Erro "Table or view does not exist":** Este erro ocorre geralmente se tentar executar o script uma segunda vez sem apagar as tabelas da primeira execução. Para recomeçar, pode usar o utilitário "SQL Scripts", selecionar o seu script, e no menu "Actions" escolher "Drop".  
* **Erro "unique constraint violated":** Acontece se tentar inserir dados duplicados em colunas com `UNIQUE`. Verifique os seus `INSERT` se modificou o script.

**Resultado Esperado:** Uma base de dados completa, robusta e com a integridade referencial garantida. A aplicação tem agora uma fundação sólida, pronta para o passo seguinte de configuração da segurança.

---

### **2\. Avaliação Crítica do Script SQL**

O script original era funcional, mas uma análise crítica revela um ponto de fragilidade significativo e algumas áreas que beneficiam de clarificação.

**Pontos de Melhoria Identificados:**

1. **Ponto Crítico Principal: Ausência da Tabela `Utilizadores`**  
     
   * **Problema:** O modelo de dados referencia múltiplos "utilizadores" do sistema (ex: `ID_Coordenador` na tabela `Turmas`, `ID_Utilizador_Criador` em `Desafios_Turma`, `ID_Autor_Da_Acao` em `Registos_De_Acoes`), mas não existe uma tabela central para os definir. Isto é uma falha de integridade. Sem ela, não podemos garantir que um `ID_Coordenador` corresponde a um utilizador válido.  
   * **Solução:** Introduzi uma nova tabela `Utilizadores`. Esta tabela irá conter os utilizadores internos do sistema (Coordenadores, Técnicos, Formadores). O `EMAIL` será a chave de negócio única. As colunas que antes eram apenas numéricas (`ID_Coordenador`, etc.) foram agora formalmente ligadas a esta nova tabela através de chaves estrangeiras. Esta alteração alinha a estrutura de dados com o modelo de segurança que será implementado no Passo 3\.

   

2. **Ponto de Clarificação: Gestão de Relações Múltiplas**  
     
   * **Observação:** O modelo de dados especifica campos como `Formadores` na tabela `Turmas` ou `Competencias_Associadas` em `Cursos` como "Relação Múltipla". O script implementa isto como um `VARCHAR2(4000)`.  
   * **Justificação:** Esta é uma decisão de design pragmática e comum em ambientes APEX. Em vez de criar tabelas de ligação adicionais (ex: `Turma_Formadores`), armazena-se uma lista de IDs separados por dois pontos (ex: '101:102:105'). O APEX gere isto de forma nativa com componentes como "Shuttle" ou "Checkbox". Esta abordagem simplifica o desenvolvimento, sendo uma forma de desnormalização controlada e aceitável para este contexto. Adicionei comentários no script para documentar esta decisão.

   

3. **Ponto de Confirmação: Comportamento `ON DELETE CASCADE`**  
     
   * **Observação:** Utilizei `ON DELETE CASCADE` em várias relações. Por exemplo, se uma `Turma` for apagada, todas as `Sessoes`, `Matriculas` e `Presencas` associadas serão automaticamente eliminadas.  
   * **Justificação:** Este é o comportamento mais lógico para manter a base de dados limpa. Se a "entidade-mãe" (a turma) deixa de existir, os seus "filhos" (as sessões, as matrículas) não têm razão para continuar a existir. Esta é a interpretação correta do modelo, mas é uma regra de negócio importante que deve ser validada.

### **3\. Script SQL Integral e Revisto (Versão 2.0)**

#### Princípio de Design: Integridade do Modelo de Dados

O modelo de dados deve ser completo e garantir a integridade referencial antes da implementação. Todas as entidades referenciadas devem existir. A "Avaliação Crítica" anterior identificou que a tabela `Utilizadores` estava em falta, o que tornaria impossível criar relações de chave estrangeira (foreign key) a partir de tabelas como `Turmas` ou `Registos_De_Acoes`. A inclusão da tabela `Utilizadores` no script (Parte 0) foi o passo corretivo essencial para garantir esta integridade.

O modelo de dados deve ser completo e garantir a integridade referencial antes da implementação. Todas as entidades referenciadas devem existir. A "Avaliação Crítica" anterior identificou que a tabela `Utilizadores` estava em falta, o que tornaria impossível criar relações de chave estrangeira (foreign key) a partir de tabelas como `Turmas` ou `Registos_De_Acoes`. A inclusão da tabela `Utilizadores` no script (Parte 0) foi o passo corretivo essencial para garantir esta integridade.

Este script inclui a nova tabela `Utilizadores` e todas as `constraints` de chave estrangeira atualizadas.

\-- \=================================================================================

\-- Script de Criação da Base de Dados para o Passaporte Competências Digitais

\-- Versão: 4.0 (UX-Driven) \- REVISÃO CRÍTICA v2.0

\-- Autor: Gemini, com base no Modelo de Dados v4.0 de HT

\-- Data: 4 de agosto de 2025

\-- REVISÃO: Adicionada tabela UTILIZADORES para integridade referencial.

\--          Adicionados comentários de clarificação sobre o design.

\-- \=================================================================================

\-- Este script é sequencial e deve ser executado na totalidade.

\-- Parte 0: Tabela de Utilizadores do Sistema (NOVO)

\-- Parte 1: Criação das Tabelas de Lookup e Inserção dos Dados Base

\-- Parte 2: Criação das Tabelas de Catálogo e Operacionais

\-- Parte 3: Criação das Tabelas de Ligação e Suporte à UX

\-- Parte 4: Definição das Relações (Constraints de Chave Estrangeira)

\-- \=================================================================================

\-- \=================================================================================

\-- PARTE 0: TABELA DE UTILIZADORES DO SISTEMA (NOVO)

\-- \=================================================================================

\-- Tabela central para os utilizadores internos (Técnicos, Formadores, Coordenadores).

\-- Essencial para a integridade dos dados e para o modelo de segurança.

CREATE TABLE Utilizadores (

    ID\_Utilizador   NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,

    Nome\_Completo   VARCHAR2(255) NOT NULL,

    Email           VARCHAR2(255) UNIQUE NOT NULL,

    \-- A coluna 'Funcao' pode ser usada para ligar aos Grupos APEX (ex: 'TECNICO', 'FORMADOR')

    Funcao          VARCHAR2(100),

    Ativo           VARCHAR2(1) DEFAULT 'S' CHECK (Ativo IN ('S', 'N')),

    Data\_Criacao    TIMESTAMP WITH TIME ZONE DEFAULT CURRENT\_TIMESTAMP

);

\-- \=================================================================================

\-- PARTE 1: TABELAS DE LOOKUP (LISTAS DE OPÇÕES) E DADOS INICIAIS

\-- \=================================================================================

\-- \[O conteúdo da Parte 1 é idêntico ao script anterior e foi omitido por brevid-- \[O conteúdo da Parte 1 é idêntico ao script anterior e foi omitido por brevidade\]

CREATE TABLE Tipos\_Area\_Competencia (

    ID\_Area\_Competencia NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,

    Nome VARCHAR2(255) NOT NULL,

    Ordem\_Exibicao NUMBER

);

INSERT INTO Tipos\_Area\_Competencia (Nome, Ordem\_Exibicao) VALUES ('Literacia de Informação e Media', 1);

INSERT INTO Tipos\_Area\_Competencia (Nome, Ordem\_Exibicao) VALUES ('Comunicação e Colaboração', 2);

INSERT INTO Tipos\_Area\_Competencia (Nome, Ordem\_Exibicao) VALUES ('Criação de Conteúdos Digitais', 3);

INSERT INTO Tipos\_Area\_Competencia (Nome, Ordem\_Exibicao) VALUES ('Segurança', 4);

INSERT INTO Tipos\_Area\_Competencia (Nome, Ordem\_Exibicao) VALUES ('Resolução de Problemas', 5);

CREATE TABLE Tipos\_Nivel\_Proficiencia (

    ID\_Nivel\_Proficiencia NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,

    Nome VARCHAR2(255) NOT NULL,

    Ordem\_Exibicao NUMBER

);

INSERT INTO Tipos\_Nivel\_Proficiencia (Nome, Ordem\_Exibicao) VALUES ('Básico', 1);

INSERT INTO Tipos\_Nivel\_Proficiencia (Nome, Ordem\_Exibicao) VALUES ('Intermédio', 2);

INSERT INTO Tipos\_Nivel\_Proficiencia (Nome, Ordem\_Exibicao) VALUES ('Avançado', 3);

CREATE TABLE Tipos\_Estado\_Curso (

    ID\_Estado\_Curso NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,

    Nome VARCHAR2(255) NOT NULL,

    Ordem\_Exibicao NUMBER

);

INSERT INTO Tipos\_Estado\_Curso (Nome, Ordem\_Exibicao) VALUES ('Em Desenho', 1);

INSERT INTO Tipos\_Estado\_Curso (Nome, Ordem\_Exibicao) VALUES ('Ativo', 2);

INSERT INTO Tipos\_Estado\_Curso (Nome, Ordem\_Exibicao) VALUES ('Inativo', 3);

INSERT INTO Tipos\_Estado\_Curso (Nome, Ordem\_Exibicao) VALUES ('Obsoleto', 4);

CREATE TABLE Tipos\_Notificacao (

    ID\_Tipo\_Notificacao NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,

    Nome VARCHAR2(255) NOT NULL,

    Ordem\_Exibicao NUMBER

);

INSERT INTO Tipos\_Notificacao (Nome, Ordem\_Exibicao) VALUES ('Automática', 1);

INSERT INTO Tipos\_Notificacao (Nome, Ordem\_Exibicao) VALUES ('Manual', 2);

CREATE TABLE Tipos\_Categoria\_Equipamento (

    ID\_Categoria\_Equipamento NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,

    Nome VARCHAR2(255) NOT NULL,

    Ordem\_Exibicao NUMBER

);

INSERT INTO Tipos\_Categoria\_Equipamento (Nome, Ordem\_Exibicao) VALUES ('Hardware', 1);

INSERT INTO Tipos\_Categoria\_Equipamento (Nome, Ordem\_Exibicao) VALUES ('Software', 2);

INSERT INTO Tipos\_Categoria\_Equipamento (Nome, Ordem\_Exibicao) VALUES ('Kit Pedagógico', 3);

CREATE TABLE Tipos\_Estado\_Pre\_Inscricao (

    ID\_Estado\_Pre\_Inscricao NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,

    Nome VARCHAR2(255) NOT NULL,

    Ordem\_Exibicao NUMBER

);

INSERT INTO Tipos\_Estado\_Pre\_Inscricao (Nome, Ordem\_Exibicao) VALUES ('Nova', 1);

INSERT INTO Tipos\_Estado\_Pre\_Inscricao (Nome, Ordem\_Exibicao) VALUES ('Contactada', 2);

INSERT INTO Tipos\_Estado\_Pre\_Inscricao (Nome, Ordem\_Exibicao) VALUES ('Convertida em Inscrição', 3);

INSERT INTO Tipos\_Estado\_Pre\_Inscricao (Nome, Ordem\_Exibicao) VALUES ('Arquivada', 4);

CREATE TABLE Tipos\_Genero (

    ID\_Genero NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,

    Nome VARCHAR2(255) NOT NULL,

    Ordem\_Exibicao NUMBER

);

INSERT INTO Tipos\_Genero (Nome, Ordem\_Exibicao) VALUES ('Feminino', 1);

INSERT INTO Tipos\_Genero (Nome, Ordem\_Exibicao) VALUES ('Masculino', 2);

INSERT INTO Tipos\_Genero (Nome, Ordem\_Exibicao) VALUES ('Outro', 3);

INSERT INTO Tipos\_Genero (Nome, Ordem\_Exibicao) VALUES ('Prefiro não indicar', 4);

CREATE TABLE Tipos\_Doc\_Identificacao (

    ID\_Tipo\_Doc\_Identificacao NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,

    Nome VARCHAR2(255) NOT NULL,

    Ordem\_Exibicao NUMBER

);

INSERT INTO Tipos\_Doc\_Identificacao (Nome, Ordem\_Exibicao) VALUES ('Cartão de Cidadão', 1);

INSERT INTO Tipos\_Doc\_Identificacao (Nome, Ordem\_Exibicao) VALUES ('Bilhete de Identidade', 2);

INSERT INTO Tipos\_Doc\_Identificacao (Nome, Ordem\_Exibicao) VALUES ('Passaporte', 3);

INSERT INTO Tipos\_Doc\_Identificacao (Nome, Ordem\_Exibicao) VALUES ('Autorização de Residência', 4);

CREATE TABLE Tipos\_Situacao\_Profissional (

    ID\_Situacao\_Profissional NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,

    Nome VARCHAR2(255) NOT NULL,

    Ordem\_Exibicao NUMBER

);

INSERT INTO Tipos\_Situacao\_Profissional (Nome, Ordem\_Exibicao) VALUES ('Empregado', 1);

INSERT INTO Tipos\_Situacao\_Profissional (Nome, Ordem\_Exibicao) VALUES ('Desempregado', 2);

INSERT INTO Tipos\_Situacao\_Profissional (Nome, Ordem\_Exibicao) VALUES ('Estudante', 3);

INSERT INTO Tipos\_Situacao\_Profissional (Nome, Ordem\_Exibicao) VALUES ('Reformado', 4);

CREATE TABLE Tipos\_Estado\_Geral\_Inscrito (

    ID\_Estado\_Geral\_Inscrito NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,

    Nome VARCHAR2(255) NOT NULL,

    Ordem\_Exibicao NUMBER

);

INSERT INTO Tipos\_Estado\_Geral\_Inscrito (Nome, Ordem\_Exibicao) VALUES ('Ativo', 1);

INSERT INTO Tipos\_Estado\_Geral\_Inscrito (Nome, Ordem\_Exibicao) VALUES ('Inativo', 2);

INSERT INTO Tipos\_Estado\_Geral\_Inscrito (Nome, Ordem\_Exibicao) VALUES ('Suspenso', 3);

CREATE TABLE Tipos\_Estado\_Turma (

    ID\_Estado\_Turma NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,

    Nome VARCHAR2(255) NOT NULL,

    Ordem\_Exibicao NUMBER

);

INSERT INTO Tipos\_Estado\_Turma (Nome, Ordem\_Exibicao) VALUES ('Planeada', 1);

INSERT INTO Tipos\_Estado\_Turma (Nome, Ordem\_Exibicao) VALUES ('Aberta para Inscrições', 2);

INSERT INTO Tipos\_Estado\_Turma (Nome, Ordem\_Exibicao) VALUES ('Em Curso', 3);

INSERT INTO Tipos\_Estado\_Turma (Nome, Ordem\_Exibicao) VALUES ('Concluída', 4);

INSERT INTO Tipos\_Estado\_Turma (Nome, Ordem\_Exibicao) VALUES ('Cancelada', 5);

CREATE TABLE Tipos\_Estado\_Dossier (

    ID\_Estado\_Dossier NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,

    Nome VARCHAR2(255) NOT NULL,

    Ordem\_Exibicao NUMBER

);

INSERT INTO Tipos\_Estado\_Dossier (Nome, Ordem\_Exibicao) VALUES ('Pendente', 1);

INSERT INTO Tipos\_Estado\_Dossier (Nome, Ordem\_Exibicao) VALUES ('Em Verificação', 2);

INSERT INTO Tipos\_Estado\_Dossier (Nome, Ordem\_Exibicao) VALUES ('Completo', 3);

CREATE TABLE Tipos\_Estado\_Matricula (

    ID\_Estado\_Matricula NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,

    Nome VARCHAR2(255) NOT NULL,

    Ordem\_Exibicao NUMBER

);

INSERT INTO Tipos\_Estado\_Matricula (Nome, Ordem\_Exibicao) VALUES ('Inscrito', 1);

INSERT INTO Tipos\_Estado\_Matricula (Nome, Ordem\_Exibicao) VALUES ('A frequentar', 2);

INSERT INTO Tipos\_Estado\_Matricula (Nome, Ordem\_Exibicao) VALUES ('Concluído com Sucesso', 3);

INSERT INTO Tipos\_Estado\_Matricula (Nome, Ordem\_Exibicao) VALUES ('Reprovado', 4);

INSERT INTO Tipos\_Estado\_Matricula (Nome, Ordem\_Exibicao) VALUES ('Desistiu', 5);

CREATE TABLE Tipos\_Nivel\_Experiencia (

    ID\_Nivel\_Experiencia NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,

    Nome VARCHAR2(255) NOT NULL,

    Ordem\_Exibicao NUMBER

);

INSERT INTO Tipos\_Nivel\_Experiencia (Nome, Ordem\_Exibicao) VALUES ('Iniciante', 1);

INSERT INTO Tipos\_Nivel\_Experiencia (Nome, Ordem\_Exibicao) VALUES ('Utilizador Casual', 2);

INSERT INTO Tipos\_Nivel\_Experiencia (Nome, Ordem\_Exibicao) VALUES ('Utilizador Frequente', 3);

INSERT INTO Tipos\_Nivel\_Experiencia (Nome, Ordem\_Exibicao) VALUES ('Avançado', 4);

CREATE TABLE Tipos\_Estado\_Presenca (

    ID\_Estado\_Presenca NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,

    Nome VARCHAR2(255) NOT NULL,

    Ordem\_Exibicao NUMBER

);

INSERT INTO Tipos\_Estado\_Presenca (Nome, Ordem\_Exibicao) VALUES ('Presente', 1);

INSERT INTO Tipos\_Estado\_Presenca (Nome, Ordem\_Exibicao) VALUES ('Ausente', 2);

INSERT INTO Tipos\_Estado\_Presenca (Nome, Ordem\_Exibicao) VALUES ('Falta Justificada', 3);

CREATE TABLE Tipos\_Metodo\_Registo (

    ID\_Metodo\_Registo NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,

    Nome VARCHAR2(255) NOT NULL,

    Ordem\_Exibicao NUMBER

);

INSERT INTO Tipos\_Metodo\_Registo (Nome, Ordem\_Exibicao) VALUES ('Manual', 1);

INSERT INTO Tipos\_Metodo\_Registo (Nome, Ordem\_Exibicao) VALUES ('QRCode', 2);

INSERT INTO Tipos\_Metodo\_Registo (Nome, Ordem\_Exibicao) VALUES ('Automático', 3);

CREATE TABLE Tipos\_Estado\_Alocacao (

    ID\_Estado\_Alocacao NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,

    Nome VARCHAR2(255) NOT NULL,

    Ordem\_Exibicao NUMBER

);

INSERT INTO Tipos\_Estado\_Alocacao (Nome, Ordem\_Exibicao) VALUES ('Requisitado', 1);

INSERT INTO Tipos\_Estado\_Alocacao (Nome, Ordem\_Exibicao) VALUES ('Em Uso', 2);

INSERT INTO Tipos\_Estado\_Alocacao (Nome, Ordem\_Exibicao) VALUES ('Devolvido', 3);

CREATE TABLE Tipos\_Funcao\_Turma (

    ID\_Funcao\_Turma NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,

    Nome VARCHAR2(255) NOT NULL,

    Ordem\_Exibicao NUMBER

);

INSERT INTO Tipos\_Funcao\_Turma (Nome, Ordem\_Exibicao) VALUES ('Formador', 1);

INSERT INTO Tipos\_Funcao\_Turma (Nome, Ordem\_Exibicao) VALUES ('Coordenador', 2);

CREATE TABLE Tipos\_Estado\_Submissao (

    ID\_Estado\_Submissao NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,

    Nome VARCHAR2(255) NOT NULL,

    Ordem\_Exibicao NUMBER

);

INSERT INTO Tipos\_Estado\_Submissao (Nome, Ordem\_Exibicao) VALUES ('Pendente', 1);

INSERT INTO Tipos\_Estado\_Submissao (Nome, Ordem\_Exibicao) VALUES ('Submetido', 2);

\-- \=================================================================================

\-- PARTE 2: TABELAS DE CATÁLOGO E OPERACIONAIS

\-- \=================================================================================

\-- \[O conteúdo da Parte 2 é idêntico ao script anterior e foi omitido por brevidade\]

CREATE TABLE Programas (

    ID\_Programa             NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,

    Nome                    VARCHAR2(255) UNIQUE NOT NULL, \--

    Descricao               CLOB \--

);

CREATE TABLE Tipos\_De\_Qualificacao (

    ID\_Qualificacao         NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,

    Nome                    VARCHAR2(255) NOT NULL, \--

    Nivel\_QEQ               NUMBER(2), \--

    Descricao               CLOB \--

);

CREATE TABLE Competencias (

    ID\_Competencia          NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,

    Nome                    VARCHAR2(255) NOT NULL, \--

    Descricao               CLOB, \--

    ID\_Area\_Competencia     NUMBER, \--

    ID\_Nivel\_Proficiencia   NUMBER, \--

    URL\_Medalha\_Digital     VARCHAR2(2000), \--

    URL\_Icone\_Badge         VARCHAR2(2000) \--

);

CREATE TABLE Cursos (

    ID\_Curso                NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,

    ID\_Programa             NUMBER, \--

    Nome                    VARCHAR2(255) NOT NULL, \--

    ID\_Estado\_Curso         NUMBER, \--

    Carga\_Horaria           NUMBER, \--

    \-- Decisão de design: Armazena múltiplos IDs (ex: '1:3:7') para ser usado por shuttles APEX. Desnormalização controlada.

    Competencias\_Associadas VARCHAR2(4000), \--

    Modalidade\_Formacao     VARCHAR2(255), \--

    Forma\_Organizacao       VARCHAR2(255), \--

    Publico\_Alvo            CLOB, \--

    Objetivos\_Gerais        CLOB, \--

    Objetivos\_Especificos   CLOB, \--

    Conteudos\_Programaticos CLOB, \--

    Metodologia\_Avaliacao   CLOB, \--

    URL\_Manual\_Digital      VARCHAR2(2000) \--

);

CREATE TABLE Modelos\_De\_Comunicacao (

    ID\_Modelo               NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,

    Nome                    VARCHAR2(255) NOT NULL, \--

    Assunto                 VARCHAR2(1000), \--

    Corpo                   CLOB, \--

    ID\_Tipo\_Notificacao     NUMBER, \--

    Evento\_Gatilho          VARCHAR2(255) \--

);

CREATE TABLE Configuracoes\_Formulario (

    ID\_Configuracao         NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,

    Nome                    VARCHAR2(255) NOT NULL, \--

    Tipo\_Formulario         VARCHAR2(100), \--

    ID\_Formulario\_Externo   VARCHAR2(255), \--

    URL\_Base                VARCHAR2(2000), \--

    Mapeamento\_Campos       CLOB CONSTRAINT ensure\_json\_mapeamento CHECK (Mapeamento\_Campos IS JSON) \--

);

CREATE TABLE Tipos\_Equipamento (

    ID\_Tipo\_Equipamento     NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,

    Nome                    VARCHAR2(255) UNIQUE NOT NULL, \--

    Descricao               CLOB, \--

    ID\_Categoria\_Equipamento NUMBER \--

);

CREATE TABLE Pre\_Inscricoes (

    ID\_Pre\_Inscricao        NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,

    Nome\_Completo           VARCHAR2(255), \--

    Email                   VARCHAR2(255), \--

    Contacto\_Telefonico     VARCHAR2(50), \--

    NIF                     NUMBER, \--

    Data\_Nascimento         DATE, \--

    Consentimento\_Dados     VARCHAR2(1) DEFAULT 'N' CHECK (Consentimento\_Dados IN ('S', 'N')), \--

    Interesses              CLOB CONSTRAINT ensure\_json\_interesses CHECK (Interesses IS JSON), \--

    Data\_Submissao          TIMESTAMP WITH TIME ZONE DEFAULT CURRENT\_TIMESTAMP, \--

    ID\_Estado\_Pre\_Inscricao NUMBER \--

);

CREATE TABLE Inscritos (

    ID\_Inscrito                 NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,

    Nome\_Completo               VARCHAR2(255) NOT NULL, \--

    Email                       VARCHAR2(255) UNIQUE NOT NULL, \--

    Contacto\_Telefonico         VARCHAR2(50), \--

    NIF                         NUMBER UNIQUE, \--

    Data\_Nascimento             DATE, \--

    ID\_Genero                   NUMBER, \--

    Naturalidade                VARCHAR2(255), \--

    Nacionalidade               VARCHAR2(255), \--

    ID\_Tipo\_Doc\_Identificacao   NUMBER, \--

    Doc\_Identificacao\_Num       VARCHAR2(100), \--

    Validade\_Doc\_Identificacao  DATE, \--

    Morada                      VARCHAR2(1000), \--

    Codigo\_Postal               VARCHAR2(50), \--

    Localidade\_Codigo\_Postal    VARCHAR2(255), \--

    ID\_Situacao\_Profissional    NUMBER, \--

    ID\_Qualificacao             NUMBER, \--

    Consentimento\_RGPD          VARCHAR2(1) DEFAULT 'N' CHECK (Consentimento\_RGPD IN ('S', 'N')), \--

    ID\_Estado\_Geral\_Inscrito    NUMBER, \--

    Interesses\_Iniciais         CLOB, \--

    Origem\_Inscricao            VARCHAR2(255), \--

    Observacoes                 CLOB, \--

    Data\_Criacao                TIMESTAMP WITH TIME ZONE DEFAULT CURRENT\_TIMESTAMP \--

);

CREATE TABLE Turmas (

    ID\_Turma                    NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,

    Nome                        VARCHAR2(255) NOT NULL, \--

    ID\_Curso                    NUMBER, \--

    \-- Decisão de design: Armazena múltiplos IDs (ex: '101:102') para ser usado por shuttles APEX. Desnormalização controlada.

    Formadores                  VARCHAR2(4000), \--

    ID\_Coordenador              NUMBER, \--

    Numero\_Da\_Turma             VARCHAR2(100), \--

    ID\_Estado\_Turma             NUMBER, \--

    ID\_Estado\_Dossier           NUMBER, \--

    Data\_Inicio                 DATE, \--

    Data\_Fim                    DATE, \--

    Local\_Formacao              VARCHAR2(255), \--

    Horario                     VARCHAR2(255), \--

    Calendarizacao\_Texto        CLOB, \--

    Estrutura\_Sessoes\_Texto     CLOB, \--

    Vagas                       NUMBER, \--

    Total\_Inquiridos            NUMBER, \--

    ID\_Config\_Avaliacao         NUMBER, \--

    ID\_Config\_Desafio\_Final     NUMBER, \--

    \-- Decisão de design: Armazena múltiplos IDs (ex: '5:8:12') para ser usado por shuttles APEX. Desnormalização controlada.

    Competencias\_Para\_Desafio   VARCHAR2(4000), \--

    Observacoes                 CLOB \--

);

CREATE TABLE Sessoes (

    ID\_Sessao                   NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,

    Nome                        VARCHAR2(255) NOT NULL, \--

    ID\_Turma                    NUMBER, \--

    \-- Decisão de design: Armazena múltiplos IDs (ex: '101:103') para ser usado por shuttles APEX. Desnormalização controlada.

    ID\_Formadores\_Sessao        VARCHAR2(4000), \--

    Data\_Sessao                 DATE, \--

    Hora\_Inicio                 VARCHAR2(5), \-- Formato esperado: HH24:MI

    Hora\_Fim                    VARCHAR2(5), \-- Formato esperado: HH24:MI

    Duracao\_Horas               NUMBER(4,2), \--

    Sumario                     CLOB, \--

    URL\_Recursos\_Pedagogicos    VARCHAR2(2000) \--

);

CREATE TABLE Matriculas (

    ID\_Matricula                NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,

    ID\_Inscrito                 NUMBER, \--

    ID\_Turma                    NUMBER, \--

    ID\_Estado\_Matricula         NUMBER, \--

    ID\_Nivel\_Experiencia        NUMBER, \--

    Respostas\_Desafio\_Final     CLOB, \--

    Classificacao\_Desafio\_Final VARCHAR2(255), \--

    Classificacao\_Final         VARCHAR2(255), \--

    Total\_Horas\_Assistidas      NUMBER(5,2), \--

    Avaliacao\_Do\_Curso          NUMBER(2), \--

    Comentarios\_Avaliacao       CLOB, \--

    Data\_De\_Inscricao           TIMESTAMP WITH TIME ZONE DEFAULT CURRENT\_TIMESTAMP, \--

    Data\_De\_Conclusao           TIMESTAMP WITH TIME ZONE, \--

    URL\_Certificado\_Conclusao   VARCHAR2(2000) \--

);

CREATE TABLE Presencas (

    ID\_Presenca         NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,

    ID\_Matricula        NUMBER, \--

    ID\_Sessao           NUMBER, \--

    ID\_Estado\_Presenca  NUMBER, \--

    Horas\_Assistidas    NUMBER(4,2), \--

    ID\_Metodo\_Registo   NUMBER, \--

    Data\_Registo        TIMESTAMP WITH TIME ZONE DEFAULT CURRENT\_TIMESTAMP \--

);

CREATE TABLE Badges\_Atribuidos (

    ID\_Badge\_Atribuido  NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,

    ID\_Inscrito         NUMBER, \--

    ID\_Competencia      NUMBER, \--

    ID\_Matricula\_Origem NUMBER, \--

    Data\_De\_Emissao     TIMESTAMP WITH TIME ZONE DEFAULT CURRENT\_TIMESTAMP, \--

    URL\_Certificado     VARCHAR2(2000) \--

);

CREATE TABLE Equipamentos\_Alocados (

    ID\_Alocacao             NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,

    ID\_Turma                NUMBER, \--

    ID\_Tipo\_Equipamento     NUMBER, \--

    Quantidade              NUMBER, \--

    Data\_Entrega            TIMESTAMP WITH TIME ZONE, \--

    Data\_Recolha\_Prevista   DATE, \--

    Data\_Recolha\_Efetiva    TIMESTAMP WITH TIME ZONE, \--

    ID\_Estado\_Alocacao      NUMBER, \--

    Observacoes             CLOB \--

);

CREATE TABLE Dossier\_Submissoes (

    ID\_Submissao            NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,

    ID\_Turma                NUMBER, \--

    ID\_Utilizador           NUMBER, \--

    ID\_Funcao\_Turma         NUMBER, \--

    ID\_Estado\_Submissao     NUMBER, \--

    Data\_Submissao          TIMESTAMP WITH TIME ZONE, \--

    URL\_Relatorio\_Satisfacao VARCHAR2(2000) \--

);

CREATE TABLE Tipos\_De\_Acao (

    ID\_Tipo\_De\_Acao     NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,

    Nome                VARCHAR2(255) NOT NULL, \--

    Palavra\_Chave       VARCHAR2(100) UNIQUE NOT NULL, \--

    Descricao           CLOB \--

);

INSERT INTO Tipos\_De\_Acao (Nome, Palavra\_Chave, Descricao) VALUES ('Pré-inscrição Recebida', 'PRE\_INSCRICAO\_RECEBIDA', 'Um novo formulário de interesse foi submetido.');

INSERT INTO Tipos\_De\_Acao (Nome, Palavra\_Chave, Descricao) VALUES ('Inscrição Criada', 'INSCRICAO\_CRIADA', 'Um perfil de inscrito foi criado no sistema.');

INSERT INTO Tipos\_De\_Acao (Nome, Palavra\_Chave, Descricao) VALUES ('Inscrição Atualizada', 'INSCRICAO\_ATUALIZADA', 'Os dados de um inscrito foram alterados.');

INSERT INTO Tipos\_De\_Acao (Nome, Palavra\_Chave, Descricao) VALUES ('Matrícula Criada', 'MATRICULA\_CRIADA', 'Um inscrito foi matriculado numa turma.');

INSERT INTO Tipos\_De\_Acao (Nome, Palavra\_Chave, Descricao) VALUES ('Estado da Matrícula Alterado', 'MATRICULA\_ESTADO\_ALTERADO', 'O estado de uma matrícula foi alterado (ex: de ""Inscrito"" para ""A frequentar"").');

INSERT INTO Tipos\_De\_Acao (Nome, Palavra\_Chave, Descricao) VALUES ('Convocatória Enviada', 'CONVOCATORIA\_ENVIADA', 'Uma comunicação (email) de convocatória foi enviada para uma turma.');

INSERT INTO Tipos\_De\_Acao (Nome, Palavra\_Chave, Descricao) VALUES ('Presenças Submetidas', 'PRESENCAS\_SUBMETIDAS', 'Um formador submeteu o registo de presenças para uma sessão.');

INSERT INTO Tipos\_De\_Acao (Nome, Palavra\_Chave, Descricao) VALUES ('Desafio Final Submetido', 'DESAFIO\_FINAL\_SUBMETIDO', 'Um formando submeteu as suas respostas ao desafio digital final.');

INSERT INTO Tipos\_De\_Acao (Nome, Palavra\_Chave, Descricao) VALUES ('Avaliação de Satisfação Submetida', 'AVALIACAO\_SATISFACAO\_SUBMETIDA', 'Um coordenador ou formador submeteu o seu relatório de avaliação de satisfação.');

INSERT INTO Tipos\_De\_Acao (Nome, Palavra\_Chave, Descricao) VALUES ('Início de Conquista de Badge', 'BADGE\_CLAIM\_STARTED', 'O formando iniciou o processo de obtenção de um badge (ex: clicou no link).');

INSERT INTO Tipos\_De\_Acao (Nome, Palavra\_Chave, Descricao) VALUES ('Badge Emitido', 'BADGE\_EMITIDO', 'Um badge foi oficialmente atribuído a um formando.');

INSERT INTO Tipos\_De\_Acao (Nome, Palavra\_Chave, Descricao) VALUES ('Certificado Emitido', 'CERTIFICADO\_EMITIDO', 'Um certificado de participação ou conclusão foi gerado.');

INSERT INTO Tipos\_De\_Acao (Nome, Palavra\_Chave, Descricao) VALUES ('Relatório Gerado', 'RELATORIO\_GERADO', 'Um utilizador gerou e/ou exportou um relatório do sistema.');

CREATE TABLE Registos\_De\_Acoes (

    ID\_Acao             NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,

    ID\_Tipo\_De\_Acao     NUMBER, \--

    ID\_Autor\_Da\_Acao    NUMBER, \--

    ID\_Contexto         NUMBER, \--

    Detalhes            CLOB, \--

    Data\_Da\_Acao        TIMESTAMP WITH TIME ZONE DEFAULT CURRENT\_TIMESTAMP \--

);

\-- \=================================================================================

\-- PARTE 3: TABELAS DE LIGAÇÃO E SUPORTE À UX

\-- \=================================================================================

\-- \[O conteúdo da Parte 3 é idêntico ao script anterior e foi omitido por brevidade\]

CREATE TABLE Turma\_Competencias\_Lecionadas (

    ID\_Turma        NUMBER NOT NULL, \--

    ID\_Competencia  NUMBER NOT NULL, \--

    CONSTRAINT pk\_turma\_comp\_lecionadas PRIMARY KEY (ID\_Turma, ID\_Competencia)

);

CREATE TABLE Desafios\_Turma (

    ID\_Desafio\_Turma    NUMBER GENERATED BY DEFAULT ON NULL AS IDENTITY PRIMARY KEY,

    ID\_Turma            NUMBER, \--

    ID\_Utilizador\_Criador NUMBER, \--

    Token\_Acesso        VARCHAR2(255) UNIQUE NOT NULL, \--

    URL\_Gerado          VARCHAR2(2000), \--

    Data\_Criacao        TIMESTAMP WITH TIME ZONE DEFAULT CURRENT\_TIMESTAMP, \--

    Data\_Expiracao      TIMESTAMP WITH TIME ZONE, \--

    Estado              VARCHAR2(50) \--

);

\-- \=================================================================================

\-- PARTE 4: DEFINIÇÃO DAS RELAÇÕES (CONSTRAINTS DE CHAVE ESTRANGEIRA) \- REVISTO

\-- \=================================================================================

\-- Relações para a tabela Competencias

ALTER TABLE Competencias ADD CONSTRAINT fk\_comp\_area FOREIGN KEY (ID\_Area\_Competencia) REFERENCES Tipos\_Area\_Competencia(ID\_Area\_Competencia);

ALTER TABLE Competencias ADD CONSTRAINT fk\_comp\_proficiencia FOREIGN KEY (ID\_Nivel\_Proficiencia) REFERENCES Tipos\_Nivel\_Proficiencia(ID\_Nivel\_Proficiencia);

\-- Relações para a tabela Cursos

ALTER TABLE Cursos ADD CONSTRAINT fk\_cursos\_programa FOREIGN KEY (ID\_Programa) REFERENCES Programas(ID\_Programa);

ALTER TABLE Cursos ADD CONSTRAINT fk\_cursos\_estado FOREIGN KEY (ID\_Estado\_Curso) REFERENCES Tipos\_Estado\_Curso(ID\_Estado\_Curso);

\-- Relações para a tabela Modelos\_De\_Comunicacao

ALTER TABLE Modelos\_De\_Comunicacao ADD CONSTRAINT fk\_modelos\_tipo\_notif FOREIGN KEY (ID\_Tipo\_Notificacao) REFERENCES Tipos\_Notificacao(ID\_Tipo\_Notificacao);

\-- Relações para a tabela Tipos\_Equipamento

ALTER TABLE Tipos\_Equipamento ADD CONSTRAINT fk\_equip\_categoria FOREIGN KEY (ID\_Categoria\_Equipamento) REFERENCES Tipos\_Categoria\_Equipamento(ID\_Categoria\_Equipamento);

\-- Relações para a tabela Pre\_Inscricoes

ALTER TABLE Pre\_Inscricoes ADD CONSTRAINT fk\_preinsc\_estado FOREIGN KEY (ID\_Estado\_Pre\_Inscricao) REFERENCES Tipos\_Estado\_Pre\_Inscricao(ID\_Estado\_Pre\_Inscricao);

\-- Relações para a tabela Inscritos

ALTER TABLE Inscritos ADD CONSTRAINT fk\_inscritos\_genero FOREIGN KEY (ID\_Genero) REFERENCES Tipos\_Genero(ID\_Genero);

ALTER TABLE Inscritos ADD CONSTRAINT fk\_inscritos\_tipodoc FOREIGN KEY (ID\_Tipo\_Doc\_Identificacao) REFERENCES Tipos\_Doc\_Identificacao(ID\_Tipo\_Doc\_Identificacao);

ALTER TABLE Inscritos ADD CONSTRAINT fk\_inscritos\_sitprof FOREIGN KEY (ID\_Situacao\_Profissional) REFERENCES Tipos\_Situacao\_Profissional(ID\_Situacao\_Profissional);

ALTER TABLE Inscritos ADD CONSTRAINT fk\_inscritos\_qualif FOREIGN KEY (ID\_Qualificacao) REFERENCES Tipos\_De\_Qualificacao(ID\_Qualificacao);

ALTER TABLE Inscritos ADD CONSTRAINT fk\_inscritos\_estadogeral FOREIGN KEY (ID\_Estado\_Geral\_Inscrito) REFERENCES Tipos\_Estado\_Geral\_Inscrito(ID\_Estado\_Geral\_Inscrito);

\-- Relações para a tabela Turmas

ALTER TABLE Turmas ADD CONSTRAINT fk\_turmas\_curso FOREIGN KEY (ID\_Curso) REFERENCES Cursos(ID\_Curso);

ALTER TABLE Turmas ADD CONSTRAINT fk\_turmas\_coordenador FOREIGN KEY (ID\_Coordenador) REFERENCES Utilizadores(ID\_Utilizador); \-- REVISTO

ALTER TABLE Turmas ADD CONSTRAINT fk\_turmas\_estado FOREIGN KEY (ID\_Estado\_Turma) REFERENCES Tipos\_Estado\_Turma(ID\_Estado\_Turma);

ALTER TABLE Turmas ADD CONSTRAINT fk\_turmas\_dossier FOREIGN KEY (ID\_Estado\_Dossier) REFERENCES Tipos\_Estado\_Dossier(ID\_Estado\_Dossier);

ALTER TABLE Turmas ADD CONSTRAINT fk\_turmas\_conf\_aval FOREIGN KEY (ID\_Config\_Avaliacao) REFERENCES Configuracoes\_Formulario(ID\_Configuracao);

ALTER TABLE Turmas ADD CONSTRAINT fk\_turmas\_conf\_desafio FOREIGN KEY (ID\_Config\_Desafio\_Final) REFERENCES Configuracoes\_Formulario(ID\_Configuracao);

\-- Relações para a tabela Sessoes

ALTER TABLE Sessoes ADD CONSTRAINT fk\_sessoes\_turma FOREIGN KEY (ID\_Turma) REFERENCES Turmas(ID\_Turma) ON DELETE CASCADE;

\-- Relações para a tabela Matriculas

ALTER TABLE Matriculas ADD CONSTRAINT fk\_matriculas\_inscrito FOREIGN KEY (ID\_Inscrito) REFERENCES Inscritos(ID\_Inscrito) ON DELETE CASCADE;

ALTER TABLE Matriculas ADD CONSTRAINT fk\_matriculas\_turma FOREIGN KEY (ID\_Turma) REFERENCES Turmas(ID\_Turma) ON DELETE CASCADE;

ALTER TABLE Matriculas ADD CONSTRAINT fk\_matriculas\_estado FOREIGN KEY (ID\_Estado\_Matricula) REFERENCES Tipos\_Estado\_Matricula(ID\_Estado\_Matricula);

ALTER TABLE Matriculas ADD CONSTRAINT fk\_matriculas\_nivelexp FOREIGN KEY (ID\_Nivel\_Experiencia) REFERENCES Tipos\_Nivel\_Experiencia(ID\_Nivel\_Experiencia);

\-- Relações para a tabela Presencas

ALTER TABLE Presencas ADD CONSTRAINT fk\_presencas\_matricula FOREIGN KEY (ID\_Matricula) REFERENCES Matriculas(ID\_Matricula) ON DELETE CASCADE;

ALTER TABLE Presencas ADD CONSTRAINT fk\_presencas\_sessao FOREIGN KEY (ID\_Sessao) REFERENCES Sessoes(ID\_Sessao) ON DELETE CASCADE;

ALTER TABLE Presencas ADD CONSTRAINT fk\_presencas\_estado FOREIGN KEY (ID\_Estado\_Presenca) REFERENCES Tipos\_Estado\_Presenca(ID\_Estado\_Presenca);

ALTER TABLE Presencas ADD CONSTRAINT fk\_presencas\_metodo FOREIGN KEY (ID\_Metodo\_Registo) REFERENCES Tipos\_Metodo\_Registo(ID\_Metodo\_Registo);

\-- Relações para a tabela Badges\_Atribuidos

ALTER TABLE Badges\_Atribuidos ADD CONSTRAINT fk\_badges\_inscrito FOREIGN KEY (ID\_Inscrito) REFERENCES Inscritos(ID\_Inscrito) ON DELETE CASCADE;

ALTER TABLE Badges\_Atribuidos ADD CONSTRAINT fk\_badges\_competencia FOREIGN KEY (ID\_Competencia) REFERENCES Competencias(ID\_Competencia);

ALTER TABLE Badges\_Atribuidos ADD CONSTRAINT fk\_badges\_matricula FOREIGN KEY (ID\_Matricula\_Origem) REFERENCES Matriculas(ID\_Matricula);

\-- Relações para a tabela Equipamentos\_Alocados

ALTER TABLE Equipamentos\_Alocados ADD CONSTRAINT fk\_equip\_aloc\_turma FOREIGN KEY (ID\_Turma) REFERENCES Turmas(ID\_Turma);

ALTER TABLE Equipamentos\_Alocados ADD CONSTRAINT fk\_equip\_aloc\_tipo FOREIGN KEY (ID\_Tipo\_Equipamento) REFERENCES Tipos\_Equipamento(ID\_Tipo\_Equipamento);

ALTER TABLE Equipamentos\_Alocados ADD CONSTRAINT fk\_equip\_aloc\_estado FOREIGN KEY (ID\_Estado\_Alocacao) REFERENCES Tipos\_Estado\_Alocacao(ID\_Estado\_Alocacao);

\-- Relações para a tabela Dossier\_Submissoes

ALTER TABLE Dossier\_Submissoes ADD CONSTRAINT fk\_dossier\_turma FOREIGN KEY (ID\_Turma) REFERENCES Turmas(ID\_Turma);

ALTER TABLE Dossier\_Submissoes ADD CONSTRAINT fk\_dossier\_utilizador FOREIGN KEY (ID\_Utilizador) REFERENCES Utilizadores(ID\_Utilizador); \-- REVISTO

ALTER TABLE Dossier\_Submissoes ADD CONSTRAINT fk\_dossier\_funcao FOREIGN KEY (ID\_Funcao\_Turma) REFERENCES Tipos\_Funcao\_Turma(ID\_Funcao\_Turma);

ALTER TABLE Dossier\_Submissoes ADD CONSTRAINT fk\_dossier\_estado FOREIGN KEY (ID\_Estado\_Submissao) REFERENCES Tipos\_Estado\_Submissao(ID\_Estado\_Submissao);

\-- Relações para a tabela Registos\_De\_Acoes

ALTER TABLE Registos\_De\_Acoes ADD CONSTRAINT fk\_acoes\_tipo FOREIGN KEY (ID\_Tipo\_De\_Acao) REFERENCES Tipos\_De\_Acao(ID\_Tipo\_De\_Acao);

ALTER TABLE Registos\_De\_Acoes ADD CONSTRAINT fk\_acoes\_autor FOREIGN KEY (ID\_Autor\_Da\_Acao) REFERENCES Utilizadores(ID\_Utilizador); \-- REVISTO

\-- Relações para a tabela Turma\_Competencias\_Lecionadas

ALTER TABLE Turma\_Competencias\_Lecionadas ADD CONSTRAINT fk\_turmacomp\_turma FOREIGN KEY (ID\_Turma) REFERENCES Turmas(ID\_Turma) ON DELETE CASCADE;

ALTER TABLE Turma\_Competencias\_Lecionadas ADD CONSTRAINT fk\_turmacomp\_comp FOREIGN KEY (ID\_Competencia) REFERENCES Competencias(ID\_Competencia) ON DELETE CASCADE;

\-- Relações para a tabela Desafios\_Turma

ALTER TABLE Desafios\_Turma ADD CONSTRAINT fk\_desafios\_turma FOREIGN KEY (ID\_Turma) REFERENCES Turmas(ID\_Turma) ON DELETE CASCADE;

ALTER TABLE Desafios\_Turma ADD CONSTRAINT fk\_desafios\_utilizador FOREIGN KEY (ID\_Utilizador\_Criador) REFERENCES Utilizadores(ID\_Utilizador); \-- REVISTO

\-- \=================================================================================

\-- FIM DO SCRIPT

\-- \=================================================================================
