## Relevant Files

- `docs/Plano de Implementacao - passo 2.md` - Guide for database creation; will be updated to include the principle of data model integrity.
- `docs/Plano de Implementacao - passo 3.md` - Guide for security setup; will be updated to include principles for data-driven security and robust data seeding scripts.

### Notes

- This task involves embedding key development principles and lessons learned directly into the existing implementation guides to make them more valuable for new developers.

## Tasks

- [x] 1.0 Document Data Model Integrity Principle in `passo 2` Guide
  - [x] 1.1 In `docs/Plano de Implementacao - passo 2.md`, append a new H4 section titled `Princípio de Design: Integridade do Modelo de Dados`.
  - [x] 1.2 In the new section, add text explaining the principle that all referenced entities must exist before relationships are created, using the `Utilizadores` table as the primary example.
- [x] 2.0 Document Security and Data Seeding Principles in `passo 3` Guide
  - [x] 2.1 In `docs/Plano de Implementacao - passo 3.md`, add a new H4 section titled `Princípio de Design: Segurança Orientada a Dados`.
  - [x] 2.2 In the new security section, add the principle statement about security being controlled by the database and include the `SEGURANCA_PKG.is_role` function as a code example.
  - [x] 2.3 In the same file, re-format the existing "Lições Aprendidas" section into a formal guide titled `Princípios para Scripts de Dados de Teste`.
  - [x] 2.4 Within the new data script guide, add a concise PL/SQL code block demonstrating the `RETURNING ID INTO variable` pattern as a best practice.