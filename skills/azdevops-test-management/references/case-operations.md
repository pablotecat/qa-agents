# Test Case operations

Detalle de cada operación CRUD sobre Test Cases. Supone leído `SKILL.md` (pasos universales + árbol de ramas) y `toolset.md` (mapeo general de tools).

## list cases

- **Tool:** `testplan` / `list_cases`.
- **Args:** `project`, `plan_id`, opcional `suite_id`.
- **Retorno:** array de Test Cases con `id`, `name` (título), y referencia al suite padre.
- **Uso típico:** "qué casos tiene el plan X" o "qué casos hay en la suite Y del plan Z".

## create case

- **Tool:** `testplan_test_case_write` / `create`.
- **Args mínimos:** `project`, `title`. Opcionales: `areaPath`, `iterationPath`, `priority`, `description`.
- **Confirmación requerida:** sí (crea artefacto persistente).
- **Limitación:** la tool `create` crea el work item Test Case con título y fields pero **sin pasos estructurados**. Para incluir pasos Given/When/Then, ejecuta `update_steps` a continuación.
- **Para añadirlo a una suite:** tras crear, ejecuta `testplan_test_suite_write / add_test_cases` (ver `suite-operations.md`).

## get (uno concreto)

- **Tool:** `wit_work_item` / `get` (un Test Case es un work item).
- **Args:** `id` (work item id del TC).
- **Retorno:** fields del work item incluyendo título, área, estado, description — pero los pasos estructurados pueden venir serializados en un field especial; ver el campo correspondiente al tipo `Test Case` en el proyecto.

## update steps

- **Tool:** `testplan_test_case_write` / `update_steps`.
- **Args:** `project`, `test_case_id`, `steps[]`.
- **Estructura de `steps[]`:** sigue el formato esperado por la Test Management REST API — array de pasos, cada uno con `action` (lo que se hace) y `expectedResult`. Para modelar Given/When/Then acciones compuestas, añádelas dentro del `action` del paso correspondiente.
- **Mapeo desde `QA.generator-test-cases.md`:** ver sección "Operación: import desde generator markdown" más abajo — convierte la lista numerada Given/When/Then en `steps[]` con `action` = texto del paso (incluyendo `**Given**` / `**When**` / `**Then**` como prefijo preservando el keyword gherkin) y `expectedResult` = el Expected Result nuclear del último paso `Then`.

## update otros fields

- **Tool:** `wit_work_item_write` / `update`.
- **Args:** `id`, `fields` (title, area, priority, etc.).
- **Confirmación requerida:** sí.
- **No uses esta tool para pasos** — `update_steps` es la vía correcta para preservar la estructura accionable de pasos. Usar `wit_work_item_update` con texto en `Description`/`ReproSteps` pierde la estructura (mismo problema que `az boards work-item create` con `--type "Test Case"`).

## delete

❌ **Gap verificado en el toolset del MCP.** Ninguna tool expuesta para eliminar Test Cases.

**Workaround documentado al usuario:**
1. Portal: abrir el TC desde el plan/suite → menú `... → Delete` (soft-delete o permanente según permisos).
2. REST API fuera del MCP: `DELETE https://dev.azure.com/{org}/_apis/wit/workitems/{id}?api-version=...` (requiere cliente HTTP autenticado).
3. Soft-vía: cambiar `State` del work item a `Closed` (no elimina pero retira de suites activas visualmente).

NO uses `wit_work_item_*` directo para "borrar" sin avisar — el TC puede quedar referenciado en suites y dar huérfanos. Informa del gap al usuario.

---

## Operación: import desde `QA.generator-test-cases.md`

Esta es la operación "de alto nivel" que da cabida al caso de uso principal (subir TCs generados por el pipeline QA a un Test Plan existente). No es un agente consumidor ni un hook técnico — el usuario decide cuándo invocarla desde chat.

### Prerequisitos de la operación

- Archivo `QA.generator-test-cases.md` ya generado por `QA.generator` (anatomía B: Prerrequisitos + pasos numerados Given/When/Then sin expecteds inline + último `Then` con Expected Result nuclear).
- IDs ya resueltos con el usuario: `project`, `plan_id`, `suite_id` (la suite destino debe existir — si no, créala primero con `suite-operations.md / create`).
- Para cada TC: `areaPath` e `iterationPath` (si no se especifican, resolve los defaults del proyecto consultando los defaults de team; el suite hereda el área del plan por defecto).

### Pasos de la operación

1. **Parsea el markdown** del archivo `QA.generator-test-cases.md`. Para cada Test Case (bloque `✅`/`🟡`/`⛔` de la sección "Test Cases"), extrae:
   - `TEST-ID` local (ej. `TEST-registration_001a`) — ÚSALO como prefijo del `title` del TC en ADO: `[TEST-registration_001a] Título humano del TC`, para preservar trazabilidad cuando el usuario no tenga tooling cross-link.
   - `Estado` (Ready / Provisional / Blocked) — si no es `Ready`, **pausa e informa al usuario**; los TCs provisionales pueden importarse pero se sugiere resolverlos primero. Pregunta confirmación explícita antes de seguir.
   - `Original ID`, `Acceptance Criteria cubierto`, `Suite / Área` (del bloque "Traza") — ponlos en el `description` del TC o en un field personalizado según el proceso del proyecto.
   - `Prerrequisitos` (lista en `<details>`) — concaténalos como prefacio del `action` del primer paso (un paso "Precondiciones") o como `description` del TC.
   - `Pasos numerados` (lista 1..N con prefijo Given/When/Then) — cada paso se convierte en un elemento de `steps[]`:
     - `action` = el texto del paso, preservando el keyword gherkin como prefijo en bold (`**Given** el usuario accede a...`).
     - El último paso `Then` con el "Expected Result nuclear": el `expectedResult` de ese paso = el texto del Expected Result nuclear; NO duplicarlo en el `action`.
     - Los pasos marcados `🟡 PROVISIONAL / NO DEFINIDO`: el `action` debe contener el marker y el motivo; el `expectedResult` queda vacío o con la "acción provisional escrita" del markdown.

2. **Confirma el plan de importación con el usuario** antes de crear nada: número de TCs a crear, cuántos son provisionales (si los hubo), suite destino. Pide confirmación explícita (reutiliza el patrón del paso universal 2 del `SKILL.md`).

3. **Crea cada Test Case:**
   - Para cada TC parseado, llama a `testplan_test_case_write / create` con `project`, `title` (con prefijo TEST-ID) y opcionalmente `description` con la traza.
   - Recoge el `id` retornado por cada llamada.

4. **Actualiza los pasos** de cada TC creado:
   - Llama a `testplan_test_case_write / update_steps` con el `test_case_id` y el `steps[]` mapeado en paso 1.
   - Si el `steps[]` está vacío (TC sin pasos, anomalía), informa al usuario y salta ese TC.

5. **Asocia los TCs a la suite destino:**
   - Recopila todos los `test_case_id` creados en paso 3.
   - Llama a `testplan_test_suite_write / add_test_cases` con `project`, `plan_id`, `suite_id`, `test_case_ids[]`.

6. **Reporta al usuario:**
   - N TCs creados (con IDs de work items).
   - N TCs provisionales (si los hubo — lista con IDs y motivos para resolver después).
   - Suite destino con el total de TCs asociados.
   - Enlace al portal: `https://dev.azure.com/{org}/{project}/_testPlans?planId={plan_id}`.

### Errores y continuación

- Si `update_steps` falla para un TC concreto, **NO abortes todo**: el TC ya existe como work item. Reporta al usuario qué TCs quedaron sin pasos, sigue con el resto y deja una lista de IDs para revisión manual.
- Si `add_test_cases` falla por una fracción de IDs, reintenta solo con los IDs que fallaron; los que sí se asociaron quedan válidos.
- Si el archivo `QA.generator-test-cases.md` no sigue la anatomía B (sin `<details>` con traza, sin pasos numerados, sin expected nuclear), **detente e informa al usuario** — no improvises parseo sobre formatos desconocidos.
