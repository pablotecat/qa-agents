---
name: azure-devops-testplan
description: "Plain Concepts Quality: create, list, get, update, or import Test Plans, Test Suites, and Test Cases in Azure DevOps via the official Azure DevOps MCP server. Use when managing test artefacts in ADO Test Plans, importing test cases from markdown, Excel/CSV, or another Test Plan, or syncing generated test cases into a test suite. Requires the local Azure DevOps MCP server (stdio) configured for your MCP client — see `references/mcp-setup.md`."
metadata:
  plugin: pc-quality
  author: "Pablo Otero Catrufo"
---

# Azure DevOps Test Management

CRUD over Azure DevOps Test Plans, Test Suites, and Test Cases through the official `microsoft/azure-devops-mcp` server (local stdio mode). The skill is standalone and usable on-demand; it is not tied to any specific QA pipeline or workflow.

## When to use

- The user asks to create, list, get, or update Test Plans, Test Suites, or Test Cases in Azure DevOps.
- The user wants to import test cases from an external source: a structured markdown document, an Excel/CSV file, or another Azure DevOps Test Plan.
- The user needs to update test case steps while preserving the structured step format (one action/expected-result pair per step, rendered as a pass/fail checklist by the Test Plans UI).
- The user asks to create a Test Suite and add existing Test Cases to it.
- The user asks to sync generated or external test cases into a target Test Suite.

## When not to use

- Managing Azure DevOps boards, work items, iterations, or area paths — out of scope.
- Committing, pushing, branching, or managing pull requests in Azure DevOps repos — out of scope.
- Writing or updating a PR description or linking work items to a PR — out of scope.
- General code-quality review or static analysis — out of scope.

## Prerequisites

Before running any operation, verify that the local Azure DevOps MCP server (`ado`, stdio, domains `-d core work-items test-plans`) is configured for your MCP client AND connected. The configuration file location and shape differ per client (VS Code → `.vscode/mcp.json`, Cursor → `.cursor/mcp.json`, OpenCode → `opencode.json`, Codex → `~/.codex/config.toml`, etc.), so do not assume `.vscode/mcp.json` is the only place it can live.

On the first use of the skill in a workspace, load `references/mcp-setup.md` and follow its first-run flow:

1. Resolve the Azure DevOps organization slug with the user.
2. Detect the MCP client in use (per the marker table in `mcp-setup.md`).
3. Check whether a local `ado` server is already configured — if yes and pointing at the same org, skip writing; if pointing at a different org, surface the conflict to the user.
4. If not configured, write or merge the local `stdio` config using the per-client block in `references/mcp-setup.md` (preserving any other servers already present).
5. Instruct the user to restart the MCP client so the config takes effect.
6. Verify connectivity with a read-only call (`mcp_ado_core_list_projects`) before running any skill operation.

Do not improvise config outside the per-client blocks in `references/mcp-setup.md`. If the user's client is not listed there, report the gap and fall back to the upstream Getting Started guide linked from that reference. An optional remote (HTTP) mode exists for VS Code-only use with a Microsoft account; it does not work in non-Microsoft clients and is documented as a fallback in `mcp-setup.md`.

## Workflow

### Step 1: Resolve context

Before any operation, identify and confirm with the user: `organization` (the one configured in your MCP client config), `project` (Azure DevOps project name or ID), and the IDs required by the operation:

| Operation target | Required IDs |
|---|---|
| Test Plan | `project` |
| Test Suite | `project` + `plan_id` (if unknown, run `testplan` / `list_plans` first) |
| Test Case | `project` + `plan_id` + `suite_id` (if unknown, list first) — or `case_id` for get/update |

### Step 2: Discover project-specific fields (before creating or updating cases)

Before creating or updating Test Cases, run the Field discovery flow in `references/case-operations.md`. Concretely: call `wit_work_item` with action `get_type` (passing `project` and `workItemType: "Test Case"`) to retrieve the list of fields available on that work item type. Azure DevOps allows custom fields per process and project, so hardcoded field names cannot be assumed.

### Step 3: Confirm before writing

For operations that create, update, or delete persistent artefacts (create, update, delete, add-cases, import), show the user a plain summary of what will happen and ask for explicit confirmation before executing. Read-only operations (list, get) do not require confirmation.

### Step 4: Execute the operation

Invoke the MCP tool(s) according to the entity reference. Consult the matching reference to avoid improvising arguments:

| Entity | Reference |
|---|---|
| Test Plan | `references/plan-operations.md` |
| Test Suite | `references/suite-operations.md` |
| Test Case | `references/case-operations.md` (includes the import operation) |

For the exact tool names and arguments for each operation, consult `references/toolset.md` (which maps to `docs/TOOLSET.md` of the upstream `microsoft/azure-devops-mcp` repository). Tool names in the toolset reference are copied **literal** from `TOOLSET.md`. The local server registers tools with the `mcp_ado_*` prefix (e.g. `mcp_ado_testplan`, `mcp_ado_wit_work_item`); the exact prefix in the session depends on the client and server version, so before invoking, list the tools exposed by the ADO MCP server in the current session and map each reference name to the concrete function call you see.

### Step 5: Report the result

Return a concise summary: created/modified/deleted IDs, links to the Azure DevOps portal when applicable (`https://dev.azure.com/{org}/{project}/_testPlans`), and any warnings or gaps encountered.

## References

| Reference | When to load it |
|---|---|
| `references/mcp-setup.md` | **Always on first run** (to detect the MCP client and configure the local `ado` server if it does not exist), and whenever there are connection errors or the server is not running. |
| `references/toolset.md` | When you need the exact tool names and args for the test-plans domain. Single source — do not duplicate in other references. |
| `references/plan-operations.md` | CRUD operations on Test Plan. |
| `references/suite-operations.md` | CRUD operations on Test Suite. |
| `references/case-operations.md` | CRUD operations on Test Case, including the "import from external sources" operation. |
| `references/delete-instructions.md` | Deletion of Plans/Suites/Cases (verified MCP gap). Loads ALWAYS before executing or suggesting REST DELETE on any of the three entities. |

## Validation

- [ ] The context (organization, project, and the relevant IDs) is confirmed with the user.
- [ ] For write operations, a summary was shown and explicit confirmation was obtained.
- [ ] For case create/update, project-specific fields were discovered before invoking the tool (no hardcoded field names assumed).
- [ ] The MCP tool(s) executed correctly without routing or argument errors.
- [ ] The result was reported to the user with IDs and, where applicable, a portal link.
- [ ] If the requested operation is not supported by the toolset (e.g. `delete`/`remove` gaps), the user was informed of the limitation and offered the alternative documented in the reference.
- [ ] For ALL delete operations (Plan, Suite, Case), `references/delete-instructions.md` was loaded and its workflow followed end to end.

## Common pitfalls

| Pitfall | Fix |
|---|---|
| Updating test case steps via `wit_work_item_write / update` | Use `testplan_test_case_write / update_steps` to preserve the per-step structure — see `references/case-operations.md` (update other fields) for why `wit_work_item_write / update` on `Description`/`ReproSteps` fails. |
| Assuming hardcoded field names without discovery | Azure DevOps allows custom fields per process/project. Always list work item types and fields before creating or updating Test Cases. |
| Importing test cases with non-Ready status | If a source test case has a provisional or blocked status, pause and inform the user before importing. Resolve or explicitly confirm before proceeding. |
| Using `wit_work_item_*` to delete plans/suites/cases | The toolset has no delete tool for these entities — follow `references/delete-instructions.md` for the confirmed gap and the safe deletion paths. |
| Assuming `.vscode/mcp.json` is the only config location | Config location depends on the MCP client: VS Code → `.vscode/mcp.json`, Cursor → `.cursor/mcp.json`, OpenCode → `opencode.json`, Codex → `~/.codex/config.toml`, Claude Code → CLI-registered, Claude Desktop → `claude_desktop_config.json`, etc. Detect the client per `references/mcp-setup.md` (first-run flow) before writing config. |
| Trying to use the remote HTTP endpoint in a non-Microsoft client | Entra ID does not support OAuth Dynamic Client Registration for non-Microsoft clients; the remote `mcp.dev.azure.com` endpoint fails to authenticate. Use the local stdio mode (`npx -y @azure-devops/mcp`) — it works in every supported client via interactive browser sign-in. |
| Composing long CLI commands on Windows | This skill does not compose `az` CLI commands — everything goes through MCP. The local `npx @azure-devops/mcp` server has no `az` CLI surface; if you ever compose a long shell command, remember the `cmd.exe` 8191-char limit (use PowerShell, not `cmd`). |
