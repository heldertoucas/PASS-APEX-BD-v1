## Relevant Files

- **Database Package:** `APP_UTIL_PKG` - A new or existing utility package to hold shared business logic. Will contain the function to check if a pre-inscribed citizen is new.
- **APEX Page:** `Novas Pré-Inscrições` (Interactive Grid) - The main "inbox" page for the Technician.
- **APEX Page:** `Processar Pré-Inscrição` (Modal Dialog Form) - The form used to process a single pre-inscription.

### Notes

- This implementation will be done entirely within the Oracle APEX App Builder and the Database.
- For the batch operation, the use of the `APEX_COLLECTION` package is the recommended best practice to manage the set of selected rows.
- Authorization Schemes (e.g., `is_tecnico`) will be used to secure the pages.

## Tasks

- [ ] 1.0 Backend Preparation: Create Supporting PL/SQL Logic
  - [ ] 1.1 Create or amend a utility PL/SQL package (e.g., `APP_UTIL_PKG`) in SQL Workshop.
  - [ ] 1.2 In the package, create a function `is_pre_inscrito_novo(p_nif IN PRE_INSCRICOES.NIF%TYPE, p_email IN PRE_INSCRICOES.EMAIL%TYPE) RETURN VARCHAR2` that checks the `INSCRITOS` table. It should return 'S' if no match is found, and 'N' if a match is found.

- [ ] 2.0 Build the "Novas Pré-Inscrições" Interactive Grid Page
  - [ ] 2.1 Create a new APEX page named "Novas Pré-Inscrições" of type **Interactive Grid** using the Create Page Wizard.
  - [ ] 2.2 Set the Interactive Grid's data source to a SQL Query selecting from `PRE_INSCRICOES` where `ID_ESTADO_PRE_INSCRICAO = 1`.
  - [ ] 2.3 In the SQL Query, add a column that calls the function from task 1.2 (e.g., `APP_UTIL_PKG.is_pre_inscrito_novo(NIF, EMAIL) as IS_NOVO`).
  - [ ] 2.4 Configure the `IS_NOVO` column to be of type "HTML Expression". Use a CASE statement to display a visual tag (e.g., `<span class="u-color-35-bg">NOVO</span>` for 'S' and `<span class="u-color-3-bg">EXISTENTE</span>` for 'N'). Set the column's "Escape special characters" attribute to "No".
  - [ ] 2.5 Create a link-type column or a button that navigates to the modal page (from Task 3.0), passing the `ID_PRE_INSCRICAO` of the clicked row.
  - [ ] 2.6 Create a navigation menu entry for this page using the Page Designer.

- [ ] 3.0 Build the "Processar Pré-Inscrição" Modal Form Page
  - [ ] 3.1 Create a new APEX page of type "Form" with the mode "Modal Dialog". Name it "Processar Pré-Inscrição", based on the `INSCRITOS` table.
  - [ ] 3.2 Create all necessary page items for the `INSCRITOS` columns using the Page Designer.
  - [ ] 3.3 Create a hidden page item to receive the pre-inscription ID (e.g., `PXX_ID_PRE_INSCRICAO`).
  - [ ] 3.4 Create a hidden page item to control the form's mode (e.g., `PXX_MODO`).
  - [ ] 3.5 Create two buttons in the dialog footer: "Criar Inscrito" and "Atualizar Inscrito".
  - [ ] 3.6 Set the Server-Side Condition for the "Criar Inscrito" button to `Item = Value`, with Item=`PXX_MODO` and Value=`CREATE`.
  - [ ] 3.7 Set the Server-Side Condition for the "Atualizar Inscrito" button to `Item = Value`, with Item=`PXX_MODO` and Value=`UPDATE`.

- [ ] 4.0 Implement Single Pre-inscription Processing Logic
  - [ ] 4.1 On the modal page (Task 3.0), create a "Pre-Rendering" (Before Header) process.
  - [ ] 4.2 In this process, write PL/SQL to fetch the `PRE_INSCRICOES` record, check for an existing `Inscrito` using `APP_UTIL_PKG.is_pre_inscrito_novo`, and then either pre-fill the form with pre-inscription data (for new citizens) or load the existing `Inscrito` data. Set `PXX_MODO` and display a notification accordingly.
  - [ ] 4.3 Create an "After Submit" process that runs after the built-in "Form - Automatic Row Processing".
  - [ ] 4.4 In this process, write PL/SQL to `UPDATE PRE_INSCRICOES SET ID_ESTADO_PRE_INSCRICAO = 3 WHERE ID_PRE_INSCRICAO = :PXX_ID_PRE_INSCRICAO`. Ensure it runs for both CREATE and SAVE (update) requests.

- [ ] 5.0 Implement Batch Processing using APEX_COLLECTION
  - [ ] 5.1 On the Interactive Grid page, create a button in the toolbar named `PROCESSAR_LOTE` with the label "Processar em Lote".
  - [ ] 5.2 Create a new page process (e.g., "Add to Collection") that is conditional on the `PROCESSAR_LOTE` button being pressed.
  - [ ] 5.3 In this process, write PL/SQL to: 
    a. Use `APEX_COLLECTION.CREATE_OR_TRUNCATE_COLLECTION` to create/clear a collection (e.g., 'PRE_INSC_SELECIONADAS').
    b. Populate the collection with the `ID_PRE_INSCRICAO` from the rows the user has selected in the Interactive Grid.
  - [ ] 5.4 Create a second page process (e.g., "Process Collection") that runs after the first one, also conditional on the `PROCESSAR_LOTE` button.
  - [ ] 5.5 In this process, write PL/SQL to loop through the collection created in task 5.3. For each member, perform the logic: check if the citizen is new, `INSERT` into `INSCRITOS`, and `UPDATE` the `PRE_INSCRICOES` status. If the citizen exists, do nothing.
  - [ ] 5.6 Add a final step to the second process to clear/delete the collection.

- [ ] 6.0 Apply Security and Finalize Workflow
  - [ ] 6.1 Apply the `is_tecnico` authorization scheme to both the Interactive Grid page and the Modal Form page.
  - [ ] 6.2 Perform end-to-end testing of the single-processing workflow for both new and existing citizens.
  - [ ] 6.3 Perform end-to-end testing of the batch-processing workflow with a mix of new and existing citizens.
  - [ ] 6.4 Review all user-facing labels, help texts, and notification messages for clarity and correctness.
