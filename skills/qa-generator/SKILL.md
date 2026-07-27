---
name: qa-generator
description: Workflow para crear Test Cases con pasos numerados Given/When/Then desde planificación o requisitos. Usar para generar QA.generator-test-cases.md.
disable-model-invocation: true
argument-hint: "Handoff del planner o analysis-report de documentation con requisitos, suites y nombres de tests. Opcional: 'to <path>' para destino, o 'preview'/'no-save' para chat-only."
user-invocable: true
compatibility: 
  - agents: [QA.generator]
---

Workflow de generación de Test Cases: diseña Test Cases con pasos numerados Given/When/Then y entrega el documento `QA.generator-test-cases.md`. El flujo operativo se divide en archivos bajo `./steps/`. DEBES seguir la secuencia de pasos y las reglas de cada uno.

## Mapa de pasos

`01 Análisis de Entrada` → `02 Particionado por Acceptance Criteria (verificación de IDs en origen)` → `03 Diseño de Pasos de Test Cases` → `04 Marcaje de Provisionales` → `05 Revisión de Trazabilidad` → `06 Generación de Reporte`

## Guardarrail de entregables (reporte final)

El único paso que escribe el **entregable final** (el reporte `QA.generator-test-cases.md`) es el paso 06. Los pasos 01–05 solo construyen estado interno: asimilar entrada, particionar por AC, redactar pasos, marcar provisionales, verificar trazabilidad.

> **No confundir con el work-log**: el work-log **no** es un entregable final, es **traza incremental de ejecución**. Se define en la sección siguiente.

## Log de Trabajo (traza incremental)

El work-log `QA.generator-work-log.md` es **traza incremental**. Se escribe **una fila tras cada paso, dentro de ese paso**, siguiendo la plantilla canónica en `references/work-log-template.md` (formato único; no uses otro).

## Invariante canónica: verificación de IDs en splits

La verificación de IDs en splits (presencia de `Original ID` + patrón de IDs derivados `{original_id}a`, `{original_id}b`, ...) se hace **en el paso 02, en el origen del split**. No se reabren pasos posteriores para corregir IDs: si una verificación posterior (p. ej. en el paso 05) detecta inconsistencia, se vuelve al paso 02 a corregir; los pasos 03 en adelante no corrigen IDs.

## Manejo de Bloqueos y Retroalimentacion

El pipeline QA es manual: no existe ningun orquestador que pueda invocar al agente que produjo el documento de entrada por ti. Si detectas que el documento de entrada es insuficiente para crear Test Cases (falta de Acceptance Criteria, escenarios sin contexto, requisitos ambiguos, etc.) o que la cobertura de ACs es imposible de alcanzar, NO intentes reinvocar al agente origen NI ejecutar sus instrucciones o workflow. Tu unica responsabilidad es dejar registrado el problema y dejar la decision en manos del usuario.

Si encuentras gaps que bloquean la creación de Test Cases:
- Documenta el bloqueo en el reporte `QA.generator-test-cases.md`, sección "Notas de Cierre para Revisión Humana → Decisiones Pendientes", indicando que el estado del resultado es `blocked` o `partial` (para que, si el invocador decide generar handoff vía `qa-handoff-creation`, se refleje allí).
- Especifica en esa misma sección qué no se pudo completar (equivalente a `work_performed.sections_untouched`), para que el usuario decida si reinvoca el agente origen para obtener más contexto.

Si algún paso no se puede redactar con certeza por falta de definición:
- Escribir una acción provisional en el paso afectado.
- Marcar el paso como `🟡 PROVISIONAL/NO DEFINIDO` con motivo en el paso 04 (Marcaje de Provisionales).
- No detener el flujo: avanzar al siguiente Test Case o al siguiente paso.

Si la cobertura de Acceptance Criteria es imposible de alcanzar:
- Documenta en el reporte `QA.generator-test-cases.md`, sección "Notas de Cierre para Revisión Humana → Decisiones Pendientes", que el estado del resultado es `partial` (para que, si el invocador decide generar handoff vía `qa-handoff-creation`, se refleje allí).
- Documentar la limitación en `QA.generator-test-cases.md`, sección "Notas de Cierre para Revisión Humana → Decisiones Pendientes".

## Resolución de output

Esta skill resuelve el directorio de salida (`output_dir`) así:

1. **Path explícito en la invocación**: si el usuario o el agente invocador indica un destino (patrones como `to <path>`, `save [to] <path>`, `en <path>`), úsalo como `output_dir`.
2. **Keyword `preview` o `no-save`**: si la invocación la contiene, **modo chat-only**: no se escribe nada a disco; el reporte se muestra por chat y se anuncia que no se persistió.
3. **Default**: en caso contrario, `output_dir` = `./qa-tmp/qa-generator/<timestamp>/` (relativo al cwd del workspace; `<timestamp>` en ISO8601 compacto `YYYYMMDD-HHMMSS`).

### Artefactos a escribir (salvo modo chat-only)

- Reporte `QA.generator-test-cases.md` → en `output_dir`.
- Work-log `QA.generator-work-log.md` → en `output_dir`.

### Feedback al usuario

- Tras escribir a disco: responde en chat **exactamente una línea seca** con el formato `<nombre-del-workflow> OK. Reporte: <ruta>. Work-log: <ruta>.` Prohibido mostrar cualquier parte del contenido de los archivos (ni el reporte ni el work-log). El usuario abrirá el archivo para leerlo.
- En modo chat-only (`preview`/`no-save`): muestra el reporte `QA.generator-test-cases.md` **completo** por chat y anuncia en una línea que no se persistió.

### Errores recuperables

Si el `output_dir` indicado no se puede escribir (permisos, path inválido): no preguntes; anuncia el error y cae al default `qa-tmp/` si es posible, o a chat-only si no. Solo en este caso se informa al usuario.
