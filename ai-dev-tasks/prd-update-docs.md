### 1. Introduction/Overview

The goal of this initiative is to perform a comprehensive update of all project documentation within the `/docs` folder. The recent implementation phase, as captured in `gemini-conversation.md`, introduced several critical architectural improvements. This task will synchronize the documentation with these developments to ensure it remains a consistent, accurate, and reliable source of truth for the project.

### 2. Goals

- **Consistency:** Ensure all documents are fully aligned with the final, improved application architecture.
- **Accuracy:** Update the data model, security model, and user journeys to reflect the current state of the application design.
- **Clarity:** Clean up and refine the implementation guides so they are easy to follow and free of obsolete information.
- **Maintainability:** Provide a solid and trustworthy documentation foundation for current and future developers.

### 3. User Stories

- **As a new developer,** I want to read documentation that is consistent and accurately reflects the current state of the codebase, so that I can get up to speed quickly and avoid confusion from outdated information.
- **As a project manager,** I want the documentation to be a reliable source of truth, so that I can accurately assess the project's status and plan future work.
- **As a Coordinator (user persona),** I want the documentation to reflect my ability to manage system users, so that the feature is properly understood and developed.

### 4. Functional Requirements

1.  The `Modelo de Dados.md` document **must** be updated to include the complete `Utilizadores` table definition.
2.  The `Modelo de Dados.md` document **must** be updated to show the correct foreign key relationships from `Turmas`, `Dossier_Submissoes`, `Desafios_Turma`, and `Registos_De_Acoes` to the new `Utilizadores` table.
3.  The `Experiência de Utilizador UX.md` document **must** be updated to include a new "User Management" journey within the Coordinator's role.
4.  The `Plano de Implementacao - geral.md` document **must** be updated to describe the data-driven security model and the user management feature in its high-level steps.
5.  The detailed implementation guides (`Plano de Implementacao - passo 2.md`, `passo 3.md`, and `passo 5.md`) **must** be reviewed and edited to ensure the explanatory text is perfectly consistent with the final code and logic, removing any obsolete information.

### 5. Non-Goals (Out of Scope)

- This task will **not** introduce any new application features beyond what was already decided in `gemini-conversation.md`.
- This task will **not** involve writing or changing any application code in the APEX environment.
- This task will **not** alter any files outside of the `/docs` directory.

### 6. Design Considerations

- N/A

### 7. Technical Considerations

- All updates must be based on the final state of the code and architecture as determined through the critical review process documented in `gemini-conversation.md`.
- The tone and formatting of the updates should be consistent with the existing style of each document.

### 8. Success Metrics

- All documents in the `/docs` folder are 100% consistent with each other and with the key developments (data-driven security, `Utilizadores` table, etc.).
- A third-party developer can read the documentation and gain a clear, accurate understanding of the project's data model, security architecture, and features without encountering contradictions.

### 9. Open Questions

- None at this time. The scope was clarified prior to creating this document.