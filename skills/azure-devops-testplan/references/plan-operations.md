# Test Plan operations

Detalle de cada operación CRUD sobre Test Plans. Supone leído `SKILL.md` (pasos universales + árbol de ramas) y `toolset.md` (mapeo general de tools).

## list plans

- **Tool:** `testplan` / `list_plans`.
- **Args:** `project`.
- **Retorno:** array de Test Plans con `id`, `name`, `areaPath`, `startDate`, `endDate`, etc.
- **Uso típico:** el usuario pide "qué test plans hay en {project}". Devuelve tabla plan | id | url al portal.

## create plan

- **Tool:** `testplan_test_plan_write` / `create`.
- **Args mínimos:** `project`, `name`. Opcionales: `startDate`, `endDate`, `areaPath`, `iteration`, `areaPath`.
- **Flujo:** confirma nombre y proyecto con el usuario → ejecuta → devuelve `id` + enlace `https://dev.azure.com/{org}/{project}/_testPlans?planId={id}`.
- **Confirmación requerida:** sí (crea artefacto persistente).

## get (uno concreto)

- **No hay tool directa** de get-by-id en `testplan_*`. Workaround:
  1. `testplan` / `list_plans` con `project`.
  2. Filtra por `name` o `id` en memoria.
- Si ya tienes el `plan_id` y necesitas detalles que `list_plans` no retorna, no hay atajo limpio en el toolset — considera el portal web osalir a la REST API fuera del MCP.

## update

- **Tool:** `wit_work_item_write` / `update` (un Test Plan es internamente un work item).
- **Args:** `id` del plan (work item id), `fields` (title, area, etc.).
- **Confirmación requerida:** sí.
- **Limitación:** vía `wit_work_item_update` se actualizan fields genéricos; no hay tool específica para propiedades del plan como fechas de cobertura. Para esos, vuelve al portal web.

## delete

❌ **Gap verificado en el toolset del MCP.** Ninguna tool expuesta para eliminar Test Plans.

**Workaround documentado al usuario:**
1. Vía portal: `https://dev.azure.com/{org}/{project}/_testPlans?planId={id}` → menú `... → Delete`.
2. Fuera del MCP: llamar a la Test Management REST API (`DELETE https://dev.azure.com/{org}/{project}/_apis/test/plans/{id}?api-version=...`). No hay tool wrapper, debe hacerse con `az devops invoke` o cliente HTTP autenticado.

Cuando el usuario pida delete de plan, NO improvises con `wit_*` (eso borra el work item "Test Plan" pero puede dejar huérfanos en Test Plans UI). Informa del gap y ofrece el workaround.
