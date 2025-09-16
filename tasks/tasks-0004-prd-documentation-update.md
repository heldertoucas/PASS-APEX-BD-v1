## Relevant Files

- `PASS-APEX-BD-v1/docs/Modelo de Dados.md` - The primary technical documentation for the database schema. To be updated for accuracy.
- `PASS-APEX-BD-v1/docs/Experiência de Utilizador UX.md` - Describes the application from a user's perspective. To be updated with real data examples and implementation notes.
- `PASS-APEX-BD-v1/docs/Plano de Implementacao - geral.md` - High-level implementation plan. To be cross-referenced and updated.
- `PASS-APEX-BD-v1/docs/Plano de Implementacao - passo 1.md` - Implementation step document to be reviewed for status.
- `PASS-APEX-BD-v1/docs/Plano de Implementacao - passo 2.md` - Implementation step document to be reviewed for status.
- `PASS-APEX-BD-v1/docs/Plano de Implementacao - passo 3.md` - Implementation step document to be reviewed for status.
- `PASS-APEX-BD-v1/docs/Plano de Implementacao - passo 4.md` - Implementation step document to be reviewed for status.
- `PASS-APEX-BD-v1/docs/Plano de Implementacao - passo 5.md` - Implementation step document to be reviewed for status.
- `PASS-APEX-BD-v1/tasks/dummy-data.sql` - New file to be created containing SQL INSERT statements for test data.

### Notes

- This task focuses on updating existing documentation and creating a new SQL data script. No application code changes are required.
- All file paths are relative to the project root `/home/heldertoucas/apexv1/`.

## Tasks

- [x] 1.0 Analyze all documentation and identify discrepancies
  - [x] 1.1 Read `Modelo de Dados.md` and compare its table structures against `table-ddl.txt`.
  - [x] 1.2 Read `Experiência de Utilizador UX.md` and identify user journeys and features that depend on database structures.
  - [x] 1.3 Read all `Plano de Implementacao - *.md` files to understand the originally intended implementation steps.
  - [x] 1.4 Create an internal checklist of all required changes for each document based on the analysis.
- [x] 2.0 Update the Data Model document (`Modelo de Dados.md`)
  - [x] 2.1 For each table in the DDL, ensure a corresponding entry exists in the markdown file. Add any missing tables (e.g., `TURMA_COMPETENCIAS_LECIONADAS`).
  - [x] 2.2 For each table, update the column list (name, data type, constraints) to perfectly match the DDL.
  - [x] 2.3 Review and rewrite the `Descrição / Propósito` for each table and column to ensure technical accuracy and clarity based on the overall system context.
  - [x] 2.4 Correct any spelling and grammar errors encountered.
- [x] 3.0 Update the User Experience document (`Experiência de Utilizador UX.md`)
  - [x] 3.1 Identify all generic references to users/data (e.g., "o formando", "uma turma").
  - [x] 3.2 Replace generic references with concrete examples from `tables-database.txt` (e.g., use "Maria Lúcia Martins" for an `Inscrito`).
  - [x] 3.3 Identify features described in the UX document that are not fully supported by the current schema (e.g., `URL_Certificado_Conclusao` which is in the model but might not be implemented).
  - [x] 3.4 For each discrepancy found, add a `> **Nota de Implementação:** ...` block explaining the difference between the ideal state and the current implementation.
  - [x] 3.5 Correct any spelling and grammar errors encountered.
- [x] 4.0 Update all Implementation Plan documents (`Plano de Implementacao - *.md`)
  - [x] 4.1 For each `passo-X.md` file, review the described actions and technical steps.
  - [x] 4.2 Compare the planned steps with the actual schema and data provided.
  - [x] 4.3 Add a `**Status:**` line (e.g., `**Status:** Concluído.`) to each major section to reflect its completion state.
  - [x] 4.4 If the final implementation differs from the plan, add a note explaining the deviation and the final outcome.
- [x] 5.0 Create the dummy data file
  - [x] 5.1 Create a new file named `dummy-data.sql` in the `PASS-APEX-BD-v1/tasks/` directory.
  - [x] 5.2 Populate the file with SQL `INSERT` statements to create a varied set of test data.
  - [x] 5.3 The data should include at least: 5 new `PRE_INSCRICOES`, 10 `INSCRITOS`, 4 `TURMAS` (in various states), and related `MATRICULAS` and `PRESENCAS`.