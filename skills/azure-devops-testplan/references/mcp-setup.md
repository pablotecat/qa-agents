# Azure DevOps MCP server setup

Configuration of the `microsoft/azure-devops-mcp` remote server required by this skill. **Remote (HTTP) mode** — zero local installation, automatic server-side updates, OAuth with the Microsoft account signed in to VS Code.

## `.vscode/mcp.json` file

The skill expects a server with `type: http` pointing to `https://mcp.dev.azure.com/{organization}`.

```jsonc
{
  "servers": {
    "ado-remote-mcp": {
      "url": "https://mcp.dev.azure.com/{organization}",
      "type": "http"
    }
  },
  "inputs": []
}
```

Replace `{organization}` with the Azure DevOps organization slug (no `https://`, no `dev.azure.com/`). Example: for `https://dev.azure.com/contoso` → `contoso`.

> This skill does not create this file by default. MCP configuration is opt-in: the user decides whether they want Azure DevOps management (vs Jira, Excel, etc.).

## Recommended: setup script

Run from the skill folder:

```powershell
.\scripts\install-ado-mcp.ps1
```

The script prompts for the organization slug, validates the format (alphanumeric with hyphens, 2–50 chars), and writes `.vscode/mcp.json` idempotently — preserving other MCP servers. Requires PowerShell 5.1+. Pass `-Organization contoso -Force` for non-interactive use.

If you prefer to configure manually, follow the steps below.

## Manual configuration

1. Create `.vscode/mcp.json` at the root of the project (or edit it if it already exists).
2. Paste the block above replacing `{organization}`.
3. Save and from VS Code: MCP view → Start server `ado-remote-mcp`.
4. When VS Code prompts, sign in with a Microsoft account that has access to the target Azure DevOps organization.

## Connectivity verification

After configuring, verify the server responds before using the skill:

- Open Copilot Chat in agent mode.
- Ask something simple: `"List ADO projects"`.
- If the `mcp_ado_core_list_projects` tool responds with your project list, the skill is usable.
- If you receive auth errors, sign in again in VS Code with the correct Microsoft account.

## Troubleshooting

- **HTTP 401/403:** the Microsoft account signed in to VS Code does not have access to the organization. Switch account in VS Code.
- **HTTP 404 when invoking tools:** check that `{organization}` is the correct slug (no protocol, no slashes).
- **Tools do not appear:** from VS Code → Command Palette → `MCP: List Servers` and verify that `ado-remote-mcp` is `running`. If not, start it manually.
- **You want filtered domains (only test-plans, not everything):** the remote mode exposes the full toolset; domains (`-d core work work-items test-plans`) are a **local** (stdio) option, not a remote one. If you need to narrow the loaded tools, switch to local mode (see Local alternative below).

## Local alternative (stdio) — only if your scenario requires it

The remote mode covers this skill. Only switch to local if you need a `stdio` setup (for example, air-gapped, or to limit the loaded tools with domains). In that case the config is:

```jsonc
{
  "inputs": [
    { "id": "ado_org", "type": "promptString", "description": "Azure DevOps organization name (e.g. 'contoso')" }
  ],
  "servers": {
    "ado-local": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@azure-devops/mcp", "${input:ado_org}", "-d", "core", "work-items", "test-plans"]
    }
  }
}
```

Requires Node 20+ on the target. Caches npx (~50MB) per workspace. For this skill, **the remote mode is the recommended option** and the only one documented in detail.
