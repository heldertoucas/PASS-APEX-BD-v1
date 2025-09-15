### **How-To: Reliably Start and Connect Your MCP Servers**

This guide provides the standard procedure for starting your `oracle-sqlcl` and `apex-custom` servers so they are correctly connected to the Gemini CLI.

#### **Goal**
To have both `oracle-sqlcl` and `apex-custom` show as `🟢 Ready` when you run the `/mcp` command in the Gemini CLI.

#### **Procedure**

1.  **Open a Dedicated "Server" Terminal:**
    Open a new, clean terminal window. This terminal will be used exclusively to run your background server processes. It's helpful to keep it open but minimized while you work.

2.  **Start the `oracle-sqlcl` Server:**
    In your "Server" Terminal, run the following command. This is the corrected command that prevents the server from suspending.

    ```bash
    source /Users/helder/.zshrc && sql -mcp < /dev/null > sqlcl_mcp.log 2>&1 &
    ```
    *   This command starts the `sqlcl` server in the background (`&`).
    *   It redirects input from `/dev/null` to prevent it from waiting for terminal input.
    *   It logs all output to `sqlcl_mcp.log` for future debugging.

3.  **Start the `apex-custom` Python Server:**
    In the *same* "Server" Terminal, run the following command:

    ```bash
    /opt/homebrew/bin/python3.12 /Users/helder/PASS-APEX-BD-v1/oracle-apex-mcp/mcp-servers/apex-server.py > apex_custom_mcp.log 2>&1 &
    ```
    *   This starts the Python server in the background (`&`).
    *   It logs all its output to `apex_custom_mcp.log`.

4.  **Verify the Connection:**
    Open a **separate, new terminal window** and start the Gemini CLI. Once inside Gemini, run the verification command:

    ```
    /mcp
    ```
    You should see both servers listed with a green `🟢 Ready` status.

#### **Troubleshooting**

If a server shows as `🔴 Disconnected` or is not in the list:

1.  Go back to your "Server" Terminal.
2.  Check the log file for the disconnected server.
    *   For `oracle-sqlcl` issues, run: `cat sqlcl_mcp.log`
    *   For `apex-custom` issues, run: `cat apex_custom_mcp.log`
3.  The error messages in the log file will tell you what went wrong (e.g., incorrect password, database not running, etc.).
