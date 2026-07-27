---
name: qa-worklog
description: Construye el work-log (traza incremental de ejecución) de un workflow QA. Una fila por paso del workflow, escrita dentro de ese paso, siguiendo la plantilla canónica. Se aplica durante la ejecución de workflows QA (documentation, planner, generator) o cuando se pide loguear/trazar la ejecución de un workflow QA.
compatibility:
  - agents: [QA.documentation, QA.planner, QA.generator]
---

Skill para construir el work-log de los workflows QA.

## Log de Trabajo (traza incremental)

El work-log es **traza incremental de ejecución**. Se escribe **una fila tras cada paso, dentro de ese paso**, siguiendo las instrucciones de `references/work-log-guidance.md` y la plantilla `references/assets/work-log-template.md`.

> **No confundir con el entregable final**: el work-log **no** es un reporte final, es **traza incremental** para auditoría y handoff. Cada workflow QA define su propio conteo de pasos y nombres.

## Reglas

- Crear un log por ejecución del workflow, con el nombre `QA.<workflow>-work-log.md` (ej. `QA.documentation-work-log.md`).
- Las filas son fijas: una fila por cada paso del workflow, en orden. Adapta el conteo y los nombres de pasos al workflow que se esté ejecutando.
- Rellenar cada celda de la fila al cerrar ese paso, antes de avanzar al siguiente.
- No dejar celdas vacías: usar "N/A" o "none" cuando no aplique.

## Referencias

- `references/work-log-guidance.md` — guía de formato y reglas (DEBES seguirla).
- `references/assets/work-log-template.md` — plantilla canónica del formato de tabla.
