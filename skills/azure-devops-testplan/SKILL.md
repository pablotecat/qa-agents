---
name: azure-devops-testplan
description: Azure DevOps Test Plans management. Use when the user asks to create, list, get, update or delete Test Plans, Test Suites or Test Cases in Azure DevOps via the official Azure DevOps MCP server. Branches — Plan (create / list / get), Suite (create / list / add-cases), Case (create / list / get / update steps / import from generator markdown). Requires the Azure DevOps MCP server configured in `.vscode/mcp.json`.
---

# Azure DevOps Test Management

CRUD sobre Test Plans, Test Suites y Test Cases de Azure DevOps a través del MCP oficial `microsoft/azure-devops-mcp` (remote server, modo HTTP). La skill no depende del pipeline QA: es standalone y usable on-demand.

## Prerequisito: MCP server

Antes de ejecutar cualquier operación, verifica que el servidor `ado-remote-mcp` esté configurado en `.vscode/mcp.json` (remoto: `https://mcp.dev.azure.com/{organization}`, `type: http`) y arranque correctamente desde la vista MCP de VS Code. Detalle y troubleshooting en `references/mcp-setup.md`. Si no está configurado, NO improvises: indícale al usuario que corra `scripts/install-ado-mcp.ps1` o lo configure manualmente siguiendo esa referencia.

## Árbol de ramas

Cada invocación se posiciona en una combinación verbo × entidad. Antes de ejecutar nada, identifica la rama activa:

| Entidad \ Operación | create | list | get (uno concreto) | update | delete/remove |
|---|---|---|---|---|---|
| **Test Plan** | ✅ | ✅ | ✅ (list + filtra) | ⚠️ (vía `wit_work_item_update`) | ⚠️ gap verificado |
| **Test Suite** | ✅ | ✅ | ✅ (list + filtra) | ⚠️ (vía `wit_work_item_update`) | ⚠️ gap verificado |
| **Test Case** | ✅ | ✅ | ✅ (vía `wit_work_item_get`) | ✅ (`update_steps`) | ⚠️ (vía work item) |

El detalle de cada celda (tools MCP concretas, argumentos, mapeo desde inputs comunes) vive en los references por entidad — la skill solo las dispara. NO recachear aquí el toolset: el single source of truth es `references/toolset.md`, que a su vez apunta a `docs/TOOLSET.md` del repo upstream.

## Pasos universales (aplican a toda rama)

1. **Resolver contexto.** Identifica y confirma con el usuario: `organization` (debe estar en `mcp.json`), `project` (nombre o ID de Azure DevOps), y los IDs necesarios según la operación:
   - operaciones sobre Plan: solo `project`.
   - operaciones sobre Suite: `project` + `plan_id` (si no lo sabe, ejecuta `testplan / list_plans` primero).
   - operaciones sobre Case: `project` + `plan_id` + `suite_id` (si no los sabe, lista primero) — o `case_id` para get/update.
2. **Confirmar antes de escribir.** Para operaciones destructivas o que crean artefactos persistentes (create, update, delete, add-cases), muestra al usuario un resumen plano de lo que vas a hacer y pide confirmación explícita antes de ejecutar. Operaciones read-only (list, get) no requieren confirmación.
3. **Ejecutar la operación** invocando la(s) tool(s) del MCP según el mapeo del reference de la entidad. Consulta el reference correspondiente para no improvisar argumentos.
4. **Reportar resultado.** Devuelve al usuario un resumen conciso: IDs creados/modificados/eliminados, enlaces al portal de Azure DevOps cuando aplique (`https://dev.azure.com/{org}/{project}/_testPlans`), y cualquier warning.

## References

| Reference | Cuándo cargarlo |
|---|---|
| `references/mcp-setup.md` | Si el MCP no está configurado o hay errores de conexión. Siempre en primera ejecución. |
| `references/toolset.md` | Cuando necesites los nombres exactos y args de las tools del dominio test-plans. Fuente única — no la dupliques en otros references. |
| `references/plan-operations.md` | Operaciones CRUD sobre Test Plan (rama de la tabla: columna Plan × operación). |
| `references/suite-operations.md` | Operaciones CRUD sobre Test Suite (columna Suite × operación). |
| `references/case-operations.md` | Operaciones CRUD sobre Test Case, incluida la operación "import desde `QA.generator-test-cases.md`". |

## Completion criteria

Antes de declarar cerrada una operación:

- [ ] El contexto (organization, project y los IDs relevantes) está confirmado con el usuario.
- [ ] Para operaciones de escritura, se mostró resumen y se obtuvo confirmación explícita.
- [ ] La(s) tool(s) del MCP se ejecutó correctamente sin errores de routing ni de args.
- [ ] El resultado se reportó al usuario con IDs y, cuando aplique, enlace al portal.
- [ ] Si la operación pedida no está soportada por el toolset (casos `delete`/`remove` marcados como gap), se informó al usuario de la limitación y se ofreció la vía alternativa documentada en el reference.

## Notas operativas

- **Windows + args largos:** este skill no compone comandos `az` CLI — todo pasa por MCP. La regla de `azps.ps1` no aplica aquí. Si eventualmente necesitas migrar a modo local con `npx @azure-devops/mcp`, recuerda el cap de 8191 chars de `cmd.exe` (usar PowerShell, no `cmd`).
- Importar Test Cases desde `QA.generator-test-cases.md` es una operación de Case (branch import), documentada en `references/case-operations.md`. No es un agente consumidor ni un hook automático — el usuario decide cuándo importar.
