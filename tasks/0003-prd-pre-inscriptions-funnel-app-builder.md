# Product Requirements Document: Pre-inscriptions Funnel (APEX App Builder Focus)

## 1. Introduction/Overview

This document outlines the requirements for the "Pre-inscriptions Funnel" feature, with a specific focus on its implementation using the Oracle APEX App Builder. Currently, processing incoming expressions of interest is a manual task, which can be slow and lead to data entry errors, such as creating duplicate records for existing participants.

This feature provides the **Técnico (Technician)** with an intelligent, semi-automated workflow to efficiently and accurately process new pre-inscriptions, converting them into official participant records (`Inscritos`). It acts as a gatekeeper to ensure high data quality from the very beginning of the participant's journey. Development will primarily leverage the visual and declarative capabilities of the APEX App Builder.

## 2. Goals

*   **Increase Efficiency:** Drastically reduce the time required for a Technician to process a new pre-inscription.
*   **Ensure Data Integrity:** Eliminate the creation of duplicate participant records by automatically checking for existing entries.
*   **Improve User Experience:** Provide the Technician with a clear, streamlined, and guided "inbox-style" workflow for their pending tasks within the APEX application.
*   **Enable Scalability:** Allow for the batch processing of new, unique pre-inscriptions to handle high volumes of interest.

## 3. User Stories

*   As a **Técnico**, I want to see a clear list of all new pre-inscriptions so that I know what work is pending.
*   As a **Técnico**, I want the system to automatically detect if a person from a pre-inscription already exists, so that I can avoid creating duplicate records.
*   As a **Técnico**, I want to quickly convert a valid pre-inscription into a new participant record with minimal clicks.
*   As a **Técnico**, I want to process a batch of new, unique pre-inscriptions simultaneously to save time.

## 4. Functional Requirements

1.  **Display New Pre-inscriptions:** The APEX application must display a list of all records from the `PRE_INSCRICOES` table where `ID_ESTADO_PRE_INSCRICAO` is `1` (Status: "Nova"). This will be implemented using an APEX Interactive Grid.
2.  **Visual Identification Tags:** In the list view (FR1), each pre-inscription must have a visual tag or indicator to quickly inform the Technician if the citizen is likely new or already exists in the `INSCRITOS` database (based on a NIF/email check). This will be achieved using HTML Expressions within the Interactive Grid column, calling a PL/SQL function `APP_UTIL_PKG.is_pre_inscrito_novo`.
3.  **Single Pre-inscription Processing:**
    a. Clicking on a single pre-inscription in the list must open a modal form to process it.
    b. The system must automatically query the `INSCRITOS` table for a matching `NIF` or `Email` from the selected pre-inscription.
4.  **New Citizen Workflow:** If no match is found (as per FR3.b), the modal form must be pre-filled with the data from the `PRE_INSCRICOES` record. The Technician can then review and confirm to create a new record in the `INSCRITOS` table.
5.  **Existing Citizen Workflow:** If a match is found (as per FR3.b), the modal form must load the existing data from the `INSCRITOS` record. A prominent, clear notification must be displayed on the form, informing the Technician that the citizen already exists. The Technician can then review and update the existing record.
6.  **Status Update:** Upon successful creation (FR4) or update (FR5) of an `Inscrito` record, the system must automatically update the corresponding `PRE_INSCRICOES` record's `ID_ESTADO_PRE_INSCRICAO` to `3` (Status: "Convertida em Inscrição").
7.  **Batch Processing:**
    a. The list view (FR1) must allow the Technician to select multiple pre-inscriptions via checkboxes within the Interactive Grid.
    b. A "Process in Batch" button shall be available on the Interactive Grid page.
    c. When triggered, the system must iterate through the selected pre-inscriptions. For each one that does **not** have a matching `NIF` or `Email` in the `INSCRITOS` table, the system will automatically create a new `Inscrito` record and update the pre-inscription's status to `3` ("Convertida em Inscrição").
    d. Pre-inscriptions in the batch that correspond to existing citizens will be ignored by the batch process and remain in the "Nova" list for manual review.

## 5. Non-Goals (Out of Scope)

*   This feature will **not** include a tool for merging two or more existing `Inscritos` records that are found to be duplicates of each other.
*   This feature will **not** include analytics or reporting dashboards on pre-inscription conversion rates.

## 6. Design Considerations

*   The main page should feel like an "inbox" or "to-do list" for the Technician, leveraging APEX UI components.
*   The visual tags for "new" vs. "existing" citizens should be distinct and immediately understandable (e.g., different colors or icons), implemented using APEX's HTML Expression capabilities.
*   The warning message for an existing citizen in the processing form must be highly visible to prevent accidental data changes.

## 7. Technical Considerations

*   The feature will primarily interact with the `PRE_INSCRICOES` and `INSCRITOS` tables.
*   The main list of pre-inscriptions will be implemented as an **APEX Interactive Grid** for its built-in row selection and server-side processing capabilities.
*   The status of pre-inscriptions is managed via the `ID_ESTADO_PRE_INSCRICAO` column in the `PRE_INSCRICOES` table. The relevant values are:
    *   `1`: Nova
    *   `3`: Convertida em Inscrição
*   The check for existing citizens must be performed against both the `NIF` and `Email` columns in the `INSCRITOS` table, likely using a PL/SQL function within the `APP_UTIL_PKG` package.
*   Batch processing logic should be implemented using the `APEX_COLLECTION` package to temporarily store the selected rows for server-side processing, triggered by APEX page processes.

## 8. Success Metrics

*   Reduction in the average time taken for a Technician to process a pre-inscription.
*   100% prevention of duplicate `Inscritos` being created through this funnel.
*   Positive feedback from Technicians regarding the ease of use and efficiency of the new workflow.
*   The APEX application can be deployed to a production environment.

## 9. Open Questions

*   There are no open questions at this time.
