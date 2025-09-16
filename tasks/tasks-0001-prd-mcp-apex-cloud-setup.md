## Relevant Files

- `~/.zshrc` - The user's shell configuration file, which needs to be updated to point to the new Java and Instant Client installations.
- `~/.gemini/settings.json` - The global Gemini CLI configuration file where the MCP servers are defined.
- `GEMINI.md` - The project-specific context file for the Gemini CLI.
- `/Users/helder/lib/oracle/instantclient_arm64` - The target directory for the new, clean Oracle Instant Client installation.

### Notes

- This process involves removing previously installed software and modifying system-level configuration files. Proceed with caution.
- The PRD has identified that using a non-Homebrew version of the JDK is critical to success.
- The user must download the required software (JDK, Instant Client ZIPs) manually from the official websites.

## Tasks

- [x] 1.0 Clean and Prepare the Development Environment
  - [x] 1.1 Execute `sudo rm -rf /Users/helder/lib/oracle/instantclient_23_3` to delete the old, incomplete Instant Client directory.
  - [x] 1.2 Execute `rm -rf /Users/helder/Downloads/instantclient_19_16` to delete the incorrectly installed files in the Downloads folder.
  - [x] 1.3 Create a new, empty directory for the clean installation: `mkdir -p /Users/helder/lib/oracle/instantclient_arm64`.

- [x] 2.0 Install and Configure a Compatible Java Development Kit (JDK)
  - [x] 2.1 Manually download the `.dmg` installer for **Azul Zulu JDK 17 (LTS)** for macOS ARM 64-bit.
  - [x] 2.2 Run the downloaded installer package.
  - [x] 2.3 Identify the installation path of the new JDK (typically under `/Library/Java/JavaVirtualMachines/`).
  - [x] 2.4 Update the `JAVA_HOME` export in the `~/.zshrc` file to point to the new Azul Zulu JDK path.

- [x] 3.0 Install and Configure the Oracle Instant Client
  - [x] 3.1 Manually download the **Basic**, **SQL*Plus**, and **Tools** packages for Instant Client **ARM64** from the Oracle website.
  - [x] 3.2 Unzip all three packages into the clean directory created in step 1.3 (`/Users/helder/lib/oracle/instantclient_arm64`).
  - [x] 3.3 Update the `ORACLE_HOME` export in the `~/.zshrc` file to point to the new `instantclient_arm64` directory.
  - [x] 3.4 Apply the changes to the current shell session using `source ~/.zshrc`.

- [ ] 4.0 Configure MCP Servers and Project Context
  - [x] 4.1 Verify the `oracle-sqlcl` and `apex-custom` server definitions in `~/.gemini/settings.json` are correct and point to the right executables and environment variables (including `TNS_ADMIN`).
  - [x] 4.2 Verify the `GEMINI.md` file contains the correct, specific details for the target cloud APEX application.

- [ ] 5.0 Launch and Verify the Full MCP Environment
  - [ ] 5.1 Start the `oracle-sqlcl` MCP server as a background process.
  - [ ] 5.2 Start the `apex-custom` Python MCP server as a background process.
  - [ ] 5.3 Run the `/mcp` command in a new Gemini CLI terminal to confirm both servers show a `Ready` or `Connected` status.
  - [ ] 5.4 As a final verification, run the prompt "List all APEX applications" to confirm the connection to the cloud database and APEX workspace is successful.