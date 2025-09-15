# PRD 0001: AI-Assisted APEX Development Environment Setup

## 1. Introduction/Overview

This document outlines the requirements for setting up a local development environment on macOS that enables an AI assistant (Gemini CLI) to connect to and interact with a specific, existing Oracle APEX application hosted in the Oracle Cloud. The goal is to empower a single developer to use natural language commands to query the database, analyze the APEX application's structure, and generate boilerplate code, thereby accelerating the development workflow.

## 2. Goals

- To establish a stable and secure connection from the developer's local machine to the specified Oracle Cloud Autonomous Database.
- To successfully configure and launch the `oracle-sqlcl` MCP server, enabling it to execute SQL queries against the cloud database.
- To successfully configure and launch the `apex-custom` Python MCP server, enabling it to interact with the APEX application metadata.
- To ensure the Gemini CLI recognizes both MCP servers and can delegate tasks to them effectively.

## 3. User Stories

- **As a developer, I want to** ask the CLI to describe a database table **so that** I can understand its structure without leaving my terminal.
- **As a developer, I want to** ask the CLI to list all the pages in my APEX application **so that** I can quickly get an overview of the app's components.
- **As a developer, I want to** ask the CLI to generate the SQL for a new report page based on a table **so that** I can speed up the initial phase of my development process.

## 4. Functional Requirements

1. The system must have a correctly installed and configured Oracle Instant Client for macOS (ARM64), including the Basic, SQL*Plus, and Tools packages.
2. The system's Java environment must be compatible with the Oracle JDBC driver and security providers, allowing for successful wallet-based connections.
3. The `sqlcl` tool must be configured to connect to the specified Oracle Cloud database via the provided Oracle Wallet.
4. A Python-based MCP server (`apex-custom`) must be configured to connect to the same cloud database using the wallet.
5. The user's global Gemini CLI configuration (`~/.gemini/settings.json`) must define the `oracle-sqlcl` and `apex-custom` MCP servers with the correct paths and environment variables.
6. The `oracle-sqlcl` server must be able to execute arbitrary SQL queries sent from the Gemini CLI.
7. The `apex-custom` server must be able to list all APEX applications within the target workspace.
8. The `apex-custom` server must be able to retrieve and display detailed information (pages, items) for a specific APEX application ID.
9. The `apex-custom` server must be able to generate template SQL for new APEX pages.

## 5. Non-Goals (Out of Scope)

- This setup will not be designed or tested to work on operating systems other than macOS (ARM64).
- The initial setup will not support connecting to multiple different cloud databases simultaneously.
- The project does not include the automation of a full CI/CD pipeline for APEX deployments.

## 6. Design Considerations

- This is a purely command-line interface (CLI) based environment. There is no graphical user interface (GUI).

## 7. Technical Considerations

- The Java environment has been identified as a critical and sensitive dependency. A standard, non-Homebrew JDK (such as Azul Zulu) is strongly recommended to avoid security provider conflicts that have been observed with Homebrew's OpenJDK.
- The setup requires a specific version of the Oracle Instant Client (ARM64) to ensure all necessary tools (`orapki`, etc.) and libraries are available.
- The configuration involves modifying user-specific shell configuration files (`.zshrc`) and global application settings (`~/.gemini/settings.json`). These changes should be made with care.

## 8. Success Metrics

- **Primary Metric:** The developer can run the `/mcp` command in the Gemini CLI and see both `oracle-sqlcl` and `apex-custom` servers in a `Ready` or `Connected` state.
- **Secondary Metric (a):** The developer can successfully issue the prompt "List all APEX applications" and receive a list containing the target application ("heldertou", ID 100).
- **Secondary Metric (b):** The developer can successfully issue a prompt like "Run this SQL query: SELECT status FROM user_tables WHERE table_name = 'MY_TABLE'" and receive a valid result from the cloud database.

## 9. Open Questions

- Are there any firewall, VPN, or network proxy settings on the local machine or its network that might interfere with the outbound TCPS connection on port 1522 to the Oracle Cloud?
