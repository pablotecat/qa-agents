# Toolset del dominio `test-plans` — MCP Azure DevOps

**Fuente canónica:** `docs/TOOLSET.md` del repo `microsoft/azure-devops-mcp` (rama `main`). URL: https://github.com/microsoft/azure-devops-mcp/blob/main/docs/TOOLSET.md

Este archivo es un mapa operativo: para cada operación CRUD sobre Test Plans/Suites/Cases, indica qué tool del MCP invocar. **No recachear aquí el detalle de cada arg** — consulta la fuente canónica upstream para los argumentos exactos y últimos cambios. Lo que sí cacheo aquí es el mapeo verbo-operación → tool, porque ese cruce NO está en TOOLSET.md (listado por tool, no por operación) y el agente no puede inferirlo mirando.

> ℹ️ Los nombres de tools pueden diferir entre modo remoto y local. En modo remoto, las tools se exponen con prefijo `mcp_ado_*` para algunas y sin prefijo para otras. Al ejecutar, lista las tools disponibles en la sesión MCP y adapta los nombres a lo que veas — no asumas que el nombre en este archivo es literal. La asignación funcional es:

## Resumen de tools por entidad

### Test Plan

| Operación | Tool (modo local) | Args clave |
|---|---|---|
| list plans | `testplan` / `list_plans` | `project` |
| create plan | `testplan_test_plan_write` / `create` | `project`, `name`, y otros campos del plan |
| get (uno) | `testplan` / `list_plans` + filtra por nombre | (no hay tool directa de get-by-id; usa list y filtra) |
| update | `wit_work_item_write` / `update` | `id` del plan (es un work item), fields a actualizar |
| delete | ❌ **gap verificado** — el toolset no expone `delete_plan`. Workaround: eliminar vía portal web, o POST a la Test Management REST API fuera del MCP. |

### Test Suite

| Operación | Tool (modo local) | Args clave |
|---|---|---|
| list suites | `testplan` / `list_suites` | `project`, `plan_id` |
| create suite | `testplan_test_suite_write` / `create` | `project`, `plan_id`, `suite_type`, `name`, `parent_suite_id` (si anidada) |
| get (uno) | `testplan` / `list_suites` + filtra por nombre | (no hay tool directa de get-by-id; usa list y filtra) |
| add cases to suite | `testplan_test_suite_write` / `add_test_cases` | `project`, `plan_id`, `suite_id`, `test_case_ids[]` |
| update | `wit_work_item_write` / `update` (un suite se gestiona en parte como work item) | `id` del suite, fields |
| delete | ❌ **gap verificado** — no tool `delete_suite`. Workaround: portal web o REST API fuera del MCP. |

### Test Case

| Operación | Tool (modo local) | Args clave |
|---|---|---|
| list cases | `testplan` / `list_cases` | `project`, `plan_id` (mínimo), opcional `suite_id` |
| create case | `testplan_test_case_write` / `create` | `project`, `title`, área/iteración, etc. |
| get (uno) | `wit_work_item` / `get` (un Test Case es un work item) | `id` |
| update steps | `testplan_test_case_write` / `update_steps` | `project`, `test_case_id`, `steps[]` (estructura de pasos Given/When/Then) |
| update otros fields | `wit_work_item_write` / `update` | `id`, fields (title, area, etc.) |
| delete | ❌ **gap verificado** — no tool `delete_case`. Workaround: `wit_work_item` Delete vía REST API fuera del MCP, o soft-delete desde el portal. |

## Notas de mapeo

- **Test Case es también Work Item.** Cualquier operación de "get" o "update de fields genéricos" puede usar `wit_*` en vez de `testplan_*`. `testplan_test_case_*` solo para operaciones específicas del dominio Test Plans (crear TC en contexto de plan/suite, actualizar pasos estructurados).
- **update_steps** es la tool que preserva la estructura accionable Given/When/Then. NO uses `wit_work_item_update` con `Description`/`ReproSteps` si quieres mantener pasos separados — esa vía pierde la estructura (es el mismo problema `az boards` historicamente tenía).
- **add_test_cases** no crea los TCs, los asocia a una suite existente. Para "crear TCs y asociarlos a suite de una sola vez" debe encadenarse: `testplan_test_case_write/create` por cada TC → luego `testplan_test_suite_write/add_test_cases` con los IDs resultantes. Es el patrón que usa la operación "import desde `QA.generator-test-cases.md`".

## Verificación al ejecutar

Antes de asumir un nombre de tool, lista las tools del servidor `ado-remote-mcp` disponibles en la sesión. Si alguna tool esperada no aparece, probablemente el server remoto tenga un subconjunto distinto al local (el remoto está en proceso de alineación según el warning en `TOOLSET.md` upstream). Reporta el mismatch al usuario y documenta para que la skill se mantenga sincronizada.
