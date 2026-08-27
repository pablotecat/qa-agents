# Test Suite operations

Detalle de cada operación CRUD sobre Test Suites. Supone leído `SKILL.md` (pasos universales + árbol de ramas) y `toolset.md` (mapeo general de tools).

## Contexto necesario

Toda operación sobre suites requiere `project` + `plan_id`. Si el usuario no los sabe, ejecuta primero `testplan / list_plans`.

## list suites

- **Tool:** `testplan` / `list_suites`.
- **Args:** `project`, `plan_id`.
- **Retorno:** árbol/lista de suites del plan con `id`, `name`, `suite_type` (StaticSuite, RequirementTestSuite, etc.), `parent_id`.
- **Uso típico:** "qué suites tiene el plan X". Devuelve tabla.

## create suite

- **Tool:** `testplan_test_suite_write` / `create`.
- **Args:** `project`, `plan_id`, `suite_type` (típicamente `StaticSuite` para una suite nueva genérica), `name`, `parent_suite_id` (si es sub-suite; si raíz, omitir o usar el id del plan-parent implícito).
- **Confirmación requerida:** sí.
- **Tipos de suite importantes:**
  - **`StaticSuite`** (más común): suite donde añades TCs manualmente. Es el tipo esperado para importar TCs desde un documento.
  - **`RequirementTestSuite`**: agrupa TCs por un work item Requisito. No se usa típicamente para importar TCs sueltos.
  - **`QueryBasedSuite`**: suite basada en una query WIQL.
- Si el usuario no especifica tipo, sugiere `StaticSuite` y confirma.

## get (uno concreto)

- **No hay tool directa** de get-by-id en `testplan_test_suite_*`. Workaround:
  1. `testplan` / `list_suites` con `project`, `plan_id`.
  2. Filtra por `name` o `id` en memoria.

## add cases to suite

- **Tool:** `testplan_test_suite_write` / `add_test_cases`.
- **Args:** `project`, `plan_id`, `suite_id`, `test_case_ids[]` (array de IDs de Test Cases ya creados).
- **Confirmación requerida:** sí.
- **Importante:** esta tool NO crea los Test Cases — solo los asocia a la suite. Los TCs deben existir previamente (creados vía `testplan_test_case_write/create` o ya presentes). Es la operación de cierre del flujo "import desde generator markdown".

## update

- **Tool:** `wit_work_item_write` / `update` (un suite "típico" es gestionado en parte como work item de cierto tipo; las propiedades estructurales del suite como `parent_id` o `suite_type` no se cambian vía `wit_work_item_update`).
- **Limitación real:** el toolset no da una tool limpia para re-parentar suites o cambiar su tipo. Para renombrar / cambiar areaPath, `wit_work_item_update` puede alcanzar. Para restructurar, vuelve al portal.

## delete

❌ **Gap verificado.** El toolset no expone `delete_suite`.

**Workaround documentado al usuario:**
1. Portal: `https://dev.azure.com/{org}/{project}/_testPlans?planId={plan_id}` → entra al plan → suite → menú `... → Delete`.
2. REST API fuera del MCP: `DELETE https://dev.azure.com/{org}/{project}/_apis/test/Plans/{plan_id}/suites/{suite_id}?api-version=...`.

NO uses `wit_work_item_*` para "eliminar" suites — el suite puede sobrevivir como fiel estructura del Test Plan aunque el work item asociado se borre. Informa del gap.
