## Relevant Files

- `oracle-apex-mcp/mcp-servers/apex-server.py` - The custom Python MCP server for interacting with APEX.
- `oracle-apex-mcp/mcp-servers/requirements.txt` - Python dependencies for the APEX MCP server.
- `oracle-apex-mcp/.env` - Environment variables for the Python server, primarily the database password.
- `~/.gemini/settings.json` - Gemini CLI configuration file where the MCP servers are defined.
- `GEMINI.md` - The project-specific context file for the Gemini CLI.

### Notes

- The setup process involves creating files both within this project directory and in your user home directory (`~`).
- Running the database in Docker is a one-time setup for this environment. You can start/stop the container later using `docker start oracle-db` and `docker stop oracle-db`.
- Ensure the paths in `~/.gemini/settings.json` are absolute and correct for your system.

## Tasks

- [ ] 1.0 Set up the Oracle Database Environment
  - [ ] 1.1 Run the Oracle Free database container using the `docker run` command.
  - [ ] 1.2 Retrieve the auto-generated `SYS` user password from the Docker container's logs.
  - [ ] 1.3 Connect to the database as the `SYS` user via `sqlcl` to verify access.
  - [ ] 1.4 Execute the `CREATE USER apex_mcp_user` script to create the dedicated user for the MCP server.
  - [ ] 1.5 Save the connection details for `apex_mcp_user` within `sqlcl` for easy access by the MCP server.
- [ ] 2.0 Create the Custom APEX MCP Server
  - [ ] 2.1 Create the project directory structure: `oracle-apex-mcp/mcp-servers`.
  - [ ] 2.2 Create the `mcp-servers/requirements.txt` file with the list of Python packages.
  - [ ] 2.3 Create the `mcp-servers/apex-server.py` file and populate it with the Python MCP server code from the guide.
  - [ ] 2.4 Create a Python virtual environment within the `oracle-apex-mcp` directory (`python3 -m venv venv`).
  - [ ] 2.5 Activate the virtual environment and install the dependencies using `pip install -r mcp-servers/requirements.txt`.
  - [ ] 2.6 Create a `.env` file in the `oracle-apex-mcp` directory to store the `DB_PASSWORD`.
- [ ] 3.0 Configure MCP Servers in Gemini CLI
  - [ ] 3.1 Locate and open the `~/.gemini/settings.json` file.
  - [ ] 3.2 Add the `oracle-sqlcl` server configuration block, ensuring the `DYLD_LIBRARY_PATH` is correct.
  - [ ] 3.3 Add the `apex-custom` server configuration block, ensuring the `command` and `args` paths point to the virtual environment's Python and the script, respectively.
- [ ] 4.0 Create Project-Specific Gemini Configuration
  - [ ] 4.1 Create the `GEMINI.md` file in the root of the `PASS-APEX-BD-v1` project directory.
  - [ ] 4.2 Populate the file with the project context, tool descriptions, and development rules as specified in the guide.
- [ ] 5.0 Launch and Test the Full MCP Environment
  - [ ] 5.1 Start the `oracle-sqlcl` MCP server as a background process.
  - [ ] 5.2 Start the `apex-custom` Python MCP server as a background process.
  - [ ] 5.3 Run the `/mcp` command in the Gemini CLI to verify that both servers show as `CONNECTED`.
  - [ ] 5.4 Run a test prompt to the `sqlcl` server (e.g., `descreve a tabela DEPT`).
  - [ ] 5.5 Run a test prompt to the `apex-custom` server (e.g., `lista as aplicações APEX disponíveis`).