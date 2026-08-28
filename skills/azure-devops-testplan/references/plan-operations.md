# Test Plan operations

Detail of each CRUD operation on Test Plans. Assumes `SKILL.md` (universal steps + branch table) and `toolset.md` (general tool mapping) have been read.

## list plans

- **Tool:** `mcp_ado_testplan` / `list_plans`.
- **Args:** `project`.
- **Return:** array of Test Plans with `id`, `name`, `areaPath`, `startDate`, `endDate`, etc.
- **Typical use:** the user asks "what test plans are in {project}". Return a table: plan | id | portal URL.

## create plan

- **Tool:** `mcp_ado_testplan_test_plan_write` / `create`.
- **Minimum args:** `project`, `name`. Optional: `startDate`, `endDate`, `areaPath`, `iteration`, `description`.
- **Flow:** confirm name and project with the user → execute → return `id` + link `https://dev.azure.com/{org}/{project}/_testPlans?planId={id}`.
- **Confirmation required:** yes (creates a persistent artefact).

## get (one specific plan)

- **There is no direct get-by-id tool** in `mcp_ado_testplan_*`. Workaround:
  1. `mcp_ado_testplan` / `list_plans` with `project`.
  2. Filter by `name` or `id` in memory.
- If you already have the `plan_id` and need details that `list_plans` does not return, there is no clean shortcut in the toolset — fall back to the web portal.

## update

- **Tool:** `mcp_ado_wit_work_item_write` / `update` (a Test Plan is internally a work item).
- **Args:** `id` of the plan (work item id), `fields` (title, area, etc.).
- **Confirmation required:** yes.
- **Limitation:** `mcp_ado_wit_work_item_write / update` updates generic fields; there is no specific tool for plan properties like coverage dates. For those, fall back to the web portal.

## delete

To delete a Test Plan, load and follow `references/delete-instructions.md`. The toolset exposes no `delete_plan` tool, and deletion is the highest-risk write operation in this skill.
