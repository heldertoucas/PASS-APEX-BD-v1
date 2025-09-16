
# Product Requirements Document: Comprehensive Documentation Update

## 1. Introduction/Overview
This document outlines the requirements for a comprehensive update of all project documentation located in the `/docs` directory. The existing documentation is outdated, and this task will bring it into perfect alignment with the current state of the application's database, as defined by the provided DDL and data files. The goal is to create a fully consistent, accurate, and clear set of documents that can be reliably used by developers and project managers. This task also includes the creation of dummy data tables for application testing.

## 2. Goals
*   **Accuracy:** Ensure `Modelo de Dados.md` is a perfect 1:1 representation of the production database schema.
*   **Clarity:** Update `Experiência de Utilizador UX.md` to reflect the current implementation, using concrete data for examples and adding notes for features that are still aspirational.
*   **Transparency:** Update the `Plano de Implementacao - *.md` files to accurately track which steps are complete versus those still planned.
*   **Utility:** Generate a set of dummy data tables that can be used to populate the application for testing and demonstration purposes.

## 3. User Stories
*   As a **new developer**, I want to read the project documentation so that I can have a complete and accurate understanding of the database schema and user flows without having to reverse-engineer the code.
*   As a **project manager**, I want the implementation plan documents to be updated so that I can accurately track progress and see what is complete versus what is planned.
*   As a **QA tester**, I want a set of dummy data tables so that I can easily populate a test environment with realistic and varied scenarios.

## 4. Functional Requirements

### FR1: Documentation Analysis
1.  Systematically compare all files in the `/docs` directory against the provided `table-ddl.txt` and `tables-database.txt` files to identify all discrepancies.

### FR2: Update `Modelo de Dados.md`
1.  All table structures, column names, data types, and constraints in the document must be updated to exactly match the `table-ddl.txt` file.
2.  The `Descrição / Propósito` for each table and column must be reviewed and rewritten for accuracy, reflecting its purpose as understood from the complete system context.
3.  Any tables or columns that exist in the DDL but are missing from the `Modelo de Dados.md` document must be added.

### FR3: Update `Experiência de Utilizador UX.md`
1.  Incorporate concrete examples from `tables-database.txt` into the user journey descriptions. For instance, when describing an enrolled user, refer to "Maria Lúcia Martins" (ID_INSCRITO: 1).
2.  If a described feature or user flow is not fully supported by the current database schema, **do not remove it**. Instead, add a formatted note to highlight the discrepancy. The note should look like this:
    > **Nota de Implementação:** A funcionalidade descrita para [Nome da Funcionalidade] é o estado ideal. Atualmente, a base de dados suporta [descrever o que é suportado].

### FR4: Update `Plano de Implementacao - *.md` Files
1.  Review each step in all `Plano de Implementacao - passo X.md` files.
2.  Based on the DDL and data, mark steps as "Completed" or add implementation notes if the final result differs from the original plan.

### FR5: Propose Improvements and Fixes (In Scope)
1.  If inconsistencies suggest a missing relationship, an incorrect data type, or a potential improvement in the database schema, this should be noted directly within the relevant documentation.
2.  Correct any spelling or grammar errors found during the update process to improve overall document quality.

### FR6: Create Dummy Data Tables
1.  Generate one or more files containing dummy data for the application.
2.  The data should be in a format that is easy to upload or import into the Oracle APEX application.
3.  The dummy data should cover a variety of scenarios, including:
    *   New pre-inscriptions.
    *   Enrolled users in active classes.
    *   Users who have completed courses and earned badges.
    *   Classes that are planned, in-progress, and completed.

## 5. Non-Goals (Out of Scope)
*   This task will not involve restructuring the documentation files, such as merging or splitting the `Plano de Implementacao` documents. The existing file structure must be maintained.

## 6. Design Considerations
*   All updates must maintain the existing Markdown formatting and style of the original documents.
*   Notes added to highlight discrepancies should be clearly formatted using Markdown blockquotes (`>`) to distinguish them from the original text.

## 7. Technical Considerations
*   The single source of truth for the database structure is `table-ddl.txt`.
*   The single source of truth for the current data is `tables-database.txt`.
*   The generated dummy data should be compatible with Oracle SQL syntax.

## 8. Success Metrics
*   All table definitions in `Modelo de Dados.md` are 100% aligned with the provided DDL.
*   The `Experiência de Utilizador UX.md` and `Plano de Implementacao` documents are updated with implementation status notes and contain concrete data examples.
*   A file containing dummy data tables is created and ready for use.

## 9. Open Questions
*   What format is preferred for the dummy data tables (e.g., CSV, SQL INSERT statements)?
*   Is there a specific number of dummy records desired for key tables (e.g., 10 new `Inscritos`, 5 `Turmas`)?
