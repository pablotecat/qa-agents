---
name: azure-devops-testplan
description: "Plain Concepts Quality: create, list, get, update, or import Test Plans, Test Suites, and Test Cases in Azure DevOps via the official Azure DevOps MCP server. Use when managing test artefacts in ADO Test Plans, importing test cases from markdown, Excel/CSV, or another Test Plan, or syncing generated test cases into a test suite. Requires the Azure DevOps MCP server configured in `.vscode/mcp.json`."
metadata:
  plugin: pc-quality
  author: "Pablo Otero Catrufo"
---

# Azure DevOps Test Management

CRUD over Azure DevOps Test Plans, Test Suites, and Test Cases through the official `microsoft/azure-devops-mcp` server (remote HTTP mode). The skill is standalone and usable on-demand; it is not tied to any specific QA pipeline or workflow.

## When to use

- The user asks to create, list, get, or update Test Plans, Test Suites, or Test Cases in Azure DevOps.
- The user wants to import test cases from an external source: a structured markdown document, an Excel/CSV file, or another Azure DevOps Test Plan.
- The user needs to update test case steps while preserving the structured step format (one action/expected-result pair per step, rendered as a pass/fail checklist by the Test Plans UI).
- The user asks to create a Test Suite and add existing Test Cases to it.
- The user asks to sync generated or external test cases into a target Test Suite.

## When not to use

- Managing Azure DevOps boards, work items, iterations, or area paths — use the `azure-devops-boards` skill in `pc-delivery`.
- Committing, pushing, branching, or managing pull requests in Azure DevOps repos — use the `azure-devops-repos` skill in `pc-delivery`.
- Writing or updating a PR description or linking work items to a PR — use the dedicated `pr-description` or `pr-workitems` skills in `pc-delivery`.
- General code-quality review or static analysis — use other `pc-quality` skills like `audit-repo` or `code-smells-clean-architecture`.

## Prerequisites

Before running any operation, verify that the server `ado-remote-mcp` is configured in `.vscode/mcp.json` (remote: `https://mcp.dev.azure.com/{organization}`, `type: http`) and starts correctly from the VS Code MCP view. If it is not configured:

- **Recommended:** run `.\scripts\install-ado-mcp.ps1` from the skill folder in a terminal. The script prompts for the Azure DevOps organization, validates the slug, and writes `.vscode/mcp.json` idempotently (preserving other MCP servers). Requires PowerShell 5.1+.
- **Manual:** follow the steps in `references/mcp-setup.md`.

Details and troubleshooting in `references/mcp-setup.md`. If it is not configured, do not improvise: instruct the user to configure it via the script or manually following that reference.

## Workflow

### Step 1: Resolve context

Before any operation, identify and confirm with the user: `organization` (must be in `mcp.json`), `project` (Azure DevOps project name or ID), and the IDs required by the operation:

| Operation target | Required IDs |
|---|---|
| Test Plan | `project` |
| Test Suite | `project` + `plan_id` (if unknown, run `testplan / list_plans` first) |
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

For the exact tool names and arguments for each operation, consult `references/toolset.md` (which maps to `docs/TOOLSET.md` of the upstream `microsoft/azure-devops-mcp` repository). Tool names differ between remote and local modes, so list the tools available in the current MCP session before invoking.

### Step 5: Report the result

Return a concise summary: created/modified/deleted IDs, links to the Azure DevOps portal when applicable (`https://dev.azure.com/{org}/{project}/_testPlans`), and any warnings or gaps encountered.

## References

| Reference | When to load it |
|---|---|
| `references/mcp-setup.md` | If the MCP is not configured or there are connection errors. Always on first run. |
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
| Tool name mismatch between remote and local MCP modes | List the available tools in the current MCP session and adapt names to what you see. The remote server exposes tools with a prefix for some and without for others. |
| Updating test case steps via `wit_work_item_write / update` | Use `testplan_test_case_write / update_steps` to preserve the per-step structure — see `references/case-operations.md` (update other fields) for why `wit_work_item_write / update` on `Description`/`ReproSteps` fails. |
| Assuming hardcoded field names without discovery | Azure DevOps allows custom fields per process/project. Always list work item types and fields before creating or updating Test Cases. |
| Importing test cases with non-Ready status | If a source test case has a provisional or blocked status, pause and inform the user before importing. Resolve or explicitly confirm before proceeding. |
| Using `wit_work_item_*` to delete plans/suites/cases | The toolset has no delete tool for these entities — follow `references/delete-instructions.md` for the confirmed gap and the safe deletion paths. |
| Composing long CLI commands on Windows | This skill does not compose `az` CLI commands — everything goes through MCP. If you eventually need to switch to local mode with `npx @azure-devops/mcp`, remember the `cmd.exe` 8191-char limit (use PowerShell, not `cmd`). |
