## Relevant Files

- **Database Package:** `APP_UTIL_PKG` - A new or existing utility package to hold shared business logic. Will contain the function to check if a pre-inscribed citizen is new.
- **APEX Page:** `Novas Pré-Inscrições` (Interactive Grid) - The main "inbox" page for the Technician.
- **APEX Page:** `Processar Pré-Inscrição` (Modal Dialog Form) - The form used to process a single pre-inscription.

### Notes

- This implementation will be done entirely within the Oracle APEX App Builder and the Database.
- For the batch operation, the use of the `APEX_COLLECTION` package is the recommended best practice to manage the set of selected rows.
- Authorization Schemes (e.g., `is_tecnico`) will be used to secure the pages.

## Tasks

- [x] 1.0 Backend Preparation: Create Supporting PL/SQL Logic
  - [x] 1.1 Create or amend a utility PL/SQL package (e.g., `APP_UTIL_PKG`) in SQL Workshop.
  - [x] 1.2 In the package, create a function `is_pre_inscrito_novo(p_nif IN PRE_INSCRICOES.NIF%TYPE, p_email IN PRE_INSCRICOES.EMAIL%TYPE) RETURN VARCHAR2` that checks the `INSCRITOS` table. It should return 'S' if no match is found, and 'N' if a match is found.

- [x] 2.0 Build the "Novas Pré-Inscrições" Interactive Grid Page
  - [x] 2.1 Create a new APEX page named "Novas Pré-Inscrições" of type **Interactive Grid** using the Create Page Wizard.
  - [x] 2.2 Set the Interactive Grid's data source to a SQL Query selecting from `PRE_INSCRICOES` where `ID_ESTADO_PRE_INSCRICAO = 1`.
  - [x] 2.3 In the SQL Query, add a column that calls the function from task 1.2 (e.g., `APP_UTIL_PKG.is_pre_inscrito_novo(NIF, EMAIL) as IS_NOVO`).
  - [x] 2.4 Configure the `IS_NOVO` column to be of type "HTML Expression". Use a CASE statement to display a visual tag (e.g., `<span class="u-color-35-bg">NOVO</span>` for 'S' and `<span class="u-color-3-bg">EXISTENTE</span>` for 'N'). Set the column's "Escape special characters" attribute to "No".
  - [x] 2.5 Create a link-type column or a button that navigates to the modal page (from Task 3.0), passing the `ID_PRE_INSCRICAO` of the clicked row.
  - [x] 2.6 Create a navigation menu entry for this page using the Page Designer.

- [x] 3.0 Build the "Processar Pré-Inscrição" Modal Form Page
  - [x] 3.1 Create a new APEX page of type "Form" with the mode "Modal Dialog". Name it "Processar Pré-Inscrição", based on the `INSCRITOS` table.
  - [x] 3.2 Create all necessary page items for the `INSCRITOS` columns using the Page Designer.
  - [x] 3.3 Create a hidden page item to receive the pre-inscription ID (e.g., `PXX_ID_PRE_INSCRICAO`).
  - [x] 3.4 Create a hidden page item to control the form's mode (e.g., `PXX_MODO`).
  - [x] 3.5 Create two buttons in the dialog footer: "Criar Inscrito" and "Atualizar Inscrito".
  - [x] 3.6 Set the Server-Side Condition for the "Criar Inscrito" button to `Item = Value`, with Item=`PXX_MODO` and Value=`CREATE`.
  - [x] 3.7 Set the Server-Side Condition for the "Atualizar Inscrito" button to `Item = Value`, with Item=`PXX_MODO` and Value=`UPDATE`.

- [x] 4.0 Implement Single Pre-inscription Processing Logic
  - [x] 4.1 On the modal page (Task 3.0), create a "Pre-Rendering" (Before Header) process.
  - [x] 4.2 In this process, write PL/SQL to fetch the `PRE_INSCRICOES` record, check for an existing `Inscrito` using `APP_UTIL_PKG.is_pre_inscrito_novo`, and then either pre-fill the form with pre-inscription data (for new citizens) or load the existing `Inscrito` data. Set `PXX_MODO` and display a notification accordingly.
  - [x] 4.3 Create an "After Submit" process that runs after the built-in "Form - Automatic Row Processing".
  - [x] 4.4 In this process, write PL/SQL to `UPDATE PRE_INSCRICOES SET ID_ESTADO_PRE_INSCRICAO = 3 WHERE ID_PRE_INSCRICAO = :PXX_ID_PRE_INSCRICAO`. Ensure it runs for both CREATE and SAVE (update) requests.

- [x] 5.0 Implement Batch Processing using APEX_COLLECTION
  - [x] 5.1 On the Interactive Grid page, create a button in the toolbar named `PROCESSAR_LOTE` with the label "Processar em Lote".
  - [x] 5.2 Create a new page process (e.g., "Add to Collection") that is conditional on the `PROCESSAR_LOTE` button being pressed.
  - [x] 5.3 In this process, write PL/SQL to: 
    a. Use `APEX_COLLECTION.CREATE_OR_TRUNCATE_COLLECTION` to create/clear a collection (e.g., 'PRE_INSC_SELECIONADAS').
    b. Populate the collection with the `ID_PRE_INSCRICAO` from the rows the user has selected in the Interactive Grid.
  - [x] 5.4 Create a second page process (e.g., "Process Collection") that runs after the first one, also conditional on the `PROCESSAR_LOTE` button.
  - [x] 5.5 In this process, write PL/SQL to loop through the collection created in task 5.3. For each member, perform the logic: check if the citizen is new, `INSERT` into `INSCRITOS`, and `UPDATE` the `PRE_INSCRICOES` status. If the citizen exists, do nothing.
  - [x] 5.6 Add a final step to the second process to clear/delete the collection.

- [x] 6.0 Apply Security and Finalize Workflow
  - [x] 6.1 Apply the `is_tecnico` authorization scheme to both the Interactive Grid page and the Modal Form page.
  - [x] 6.2 Perform end-to-end testing of the single-processing workflow for both new and existing citizens.
  - [x] 6.3 Perform end-to-end testing of the batch-processing workflow with a mix of new and existing citizens.
  - [x] 6.4 Review all user-facing labels, help texts, and notification messages for clarity and correctness.
