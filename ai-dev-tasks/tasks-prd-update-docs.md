## Relevant Files

- `docs/Modelo de Dados.md` - The core data model. Needs to be updated to include the new `Utilizadores` table and its relationships.
- `docs/Experiência de Utilizador UX.md` - The user experience document. Needs to be updated to include the Coordinator's new user management journey.
- `docs/Plano de Implementacao - geral.md` - The high-level project plan. Needs to be updated to reflect the more robust architecture for security and data.
- `docs/Plano de Implementacao - passo 2.md` - Technical guide for database creation. Needs a final review for consistency.
- `docs/Plano de Implementacao - passo 3.md` - Technical guide for security setup. Needs a final review for consistency.
- `docs/Plano de Implementacao - passo 5.md` - Technical guide for the pre-registration funnel. Needs verification of its final state.

### Notes

- This set of tasks involves updating documentation files. The goal is to ensure that the project's documentation accurately reflects the improved design and architecture decisions made during the initial implementation phase.

## Tasks

- [x] 1.0 Update Core Design Documents (`Modelo de Dados.md`, `Experiência de Utilizador UX.md`)
  - [x] 1.1 In `Modelo de Dados.md`, add the full table definition for the new `Utilizadores` table.
  - [x] 1.2 In `Modelo de Dados.md`, update the definitions for `Turmas`, `Dossier_Submissoes`, `Desafios_Turma`, and `Registos_De_Acoes` to correctly describe the foreign key relationship to the `Utilizadores` table.
  - [x] 1.3 In `Modelo de Dados.md`, add a note to the `Turmas.Formadores` column explaining the denormalized, colon-separated list design pattern used for APEX.
  - [x] 1.4 In `Experiência de Utilizador UX.md`, add a new sub-section under the "Jornada do Coordenador" to describe the new "User Management" flow.
  - [x] 1.5 In `Experiência de Utilizador UX.md`, add a user story for the Coordinator related to managing users and their roles.
- [x] 2.0 Update High-Level Implementation Plan (`Plano de Implementacao - geral.md`)
  - [x] 2.1 Revise the description for "Passo 2" to highlight that the final data model includes the critical `Utilizadores` table.
  - [x] 2.2 Revise the description for "Passo 3" to specify that the security model is a data-driven architecture.
  - [x] 2.3 Revise the description for "Passo 4" to explicitly mention that the Coordinator's control panel includes a user management interface.
- [ ] 3.0 Perform Final Review and Cleanup of Technical Implementation Guides (`passo-2`, `passo-3`, `passo-5`)
  - [ ] 3.1 Perform a final review of `Plano de Implementacao - passo 2.md`, ensuring the explanatory text is fully consistent with the v2.0 SQL script.
  - [ ] 3.2 Perform a final review of `Plano de Implementacao - passo 3.md`, ensuring the guide clearly explains the data-driven security model.
  - [ ] 3.3 Verify that `Plano de Implementacao - passo 5.md` is in its final, correct state, containing guides for both single-item and batch processing of pre-registrations.