# `test-plans` domain toolset — Azure DevOps MCP

**Canonical source:** `docs/TOOLSET.md` of the `microsoft/azure-devops-mcp` repository (`main` branch). URL: https://github.com/microsoft/azure-devops-mcp/blob/main/docs/TOOLSET.md

This file is an operational map: for each CRUD operation on Test Plans/Suites/Cases, it indicates which MCP tool to invoke. **Do not cache the detail of each argument here** — consult the upstream canonical source for exact arguments and latest changes. What is cached here is the verb-operation → tool mapping, because that cross-reference is NOT in TOOLSET.md (which is listed by tool, not by operation) and the agent cannot infer it by inspection.

## Tool summary by entity

### Test Plan

| Operation | Tool | Key args |
|---|---|---|
| list plans | `mcp_ado_testplan` / `list_plans` | `project` |
| create plan | `mcp_ado_testplan_test_plan_write` / `create` | `project`, `name`, and other plan fields |
| get (one) | `mcp_ado_testplan` / `list_plans` + filter by name | (no direct get-by-id tool; use list and filter) |
| update | `mcp_ado_wit_work_item_write` / `update` | `id` of the plan (it is a work item), fields to update (title, area, etc.) |
| delete | ❌ **verified gap** — no `delete_plan` tool on ADO MCP. Follow `references/delete-instructions.md`. |

### Test Suite

| Operation | Tool | Key args |
|---|---|---|
| list suites | `mcp_ado_testplan` / `list_suites` | `project`, `plan_id` |
| create suite | `mcp_ado_testplan_test_suite_write` / `create` | `project`, `plan_id`, `suite_type`, `name`, `parent_suite_id` (if nested) |
| get (one) | `mcp_ado_testplan` / `list_suites` + filter by name | (no direct get-by-id tool; use list and filter) |
| add cases to suite | `mcp_ado_testplan_test_suite_write` / `add_test_cases` | `project`, `plan_id`, `suite_id`, `test_case_ids[]` |
| update | `mcp_ado_wit_work_item_write` / `update` (a suite is partly managed as a work item) | `id` of the suite, fields (title, area, etc.) |
| delete | ❌ **verified gap** — no `delete_suite` tool on ADO MCP. Follow `references/delete-instructions.md`. |

### Test Case

| Operation | Tool | Key args |
|---|---|---|
| list cases | `mcp_ado_testplan` / `list_cases` | `project`, `plan_id` (minimum), optional `suite_id` |
| create case | `mcp_ado_testplan_test_case_write` / `create` | `project`, `title`, area/iteration, etc. |
| get (one) | `mcp_ado_wit_work_item` / `get` (a Test Case is a work item) | `id` |
| update steps | `mcp_ado_testplan_test_case_write` / `update_steps` | `project`, `test_case_id`, `steps[]` (structured steps: each with `action` and `expectedResult`) |
| update other fields | `mcp_ado_wit_work_item_write` / `update` | `id`, fields (title, area, priority, etc.) |
| delete | ❌ **verified gap** — no `delete_case` tool on ADO MCP. Follow `references/delete-instructions.md`. |

## Mapping notes

- **A Test Case is also a Work Item.** Any "get" or "generic field update" operation can use `mcp_ado_wit_*` instead of `mcp_ado_testplan_*`. Use `mcp_ado_testplan_test_case_*` only for operations specific to the Test Plans domain (create a TC in the context of a plan/suite, update structured steps).
- **update_steps** is the tool that preserves the structured step format (each step a discrete `action`/`expectedResult` pair rendered as a pass/fail checklist). Do not substitute `mcp_ado_wit_work_item_write / update` for steps — see `case-operations.md` (update other fields) for why it dumps them as a single text blob. The source format is not assumed to be Gherkin: plain numbered steps, Excel/CSV rows, or steps copied from another Test Plan are all valid inputs.
- **add_test_cases** associates existing Test Cases with a suite (it does not create them). See `suite-operations.md` (add cases to suite) for the chain pattern used by the "import test cases from external sources" operation.
