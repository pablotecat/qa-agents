# Plantilla de Log de Trabajo

Este es el formato canónico y único para `QA.generator-work-log.md`. Referenciado desde `SKILL.md`.

## Objetivo

Registrar evidencia de ejecucion por paso del workflow para auditar decisiones y facilitar handoff.

## Reglas

- Crear un log por ejecucion del agente, usando la tabla de abajo como unico formato.
- Las filas son fijas: una fila por cada paso del workflow (01 a 06), en ese orden.
- No añadir, eliminar ni reordenar filas.
- Rellenar cada celda de la fila al cerrar ese paso, antes de avanzar al siguiente.
- No dejar celdas vacias: usar "N/A" o "none" cuando no aplique.
- Registrar hechos observables (horas, artefactos, decisiones), no opiniones.
- Si un paso queda bloqueado o parcial, documentarlo en "Comentarios / Bloqueos" y detener el avance hasta resolverlo o escalarlo.

Estados permitidos (columna Estado):

- `in_progress`
- `completed`
- `blocked`
- `partial`

## Tabla de Log (Plantilla)

| Paso | Hora inicio | Hora fin | Tiempo dedicado | Modelo usado | Estado | Checklist completado | Skill usada | Artefactos generados | Comentarios / Bloqueos |
|------|-------------|----------|------------------|--------------|--------|-----------------------|-------------|------------------------|--------------------------|
| 01 - Analisis de Entrada | <HH:MM:ss> | <HH:MM:ss> | <mm:ss> | <nombre modelo> | <in_progress\|completed\|blocked\|partial> | <n/n> | <lista o N/A> | <lista o N/A> | <detalle o none> |
| 02 - Particionado por Acceptance Criteria | <HH:MM:ss> | <HH:MM:ss> | <mm:ss> | <nombre modelo> | <in_progress\|completed\|blocked\|partial> | <n/n> | <lista o N/A> | <lista o N/A> | <detalle o none> |
| 03 - Diseno de Pasos de Test Cases | <HH:MM:ss> | <HH:MM:ss> | <mm:ss> | <nombre modelo> | <in_progress\|completed\|blocked\|partial> | <n/n> | <lista o N/A> | <lista o N/A> | <detalle o none> |
| 04 - Marcaje de Provisionales | <HH:MM:ss> | <HH:MM:ss> | <mm:ss> | <nombre modelo> | <in_progress\|completed\|blocked\|partial> | <n/n> | <lista o N/A> | <lista o N/A> | <detalle o none> |
| 05 - Revision de Trazabilidad | <HH:MM:ss> | <HH:MM:ss> | <mm:ss> | <nombre modelo> | <in_progress\|completed\|blocked\|partial> | <n/n> | <lista o N/A> | <lista o N/A> | <detalle o none> |
| 06 - Generacion de Handoff y Reporte | <HH:MM:ss> | <HH:MM:ss> | <mm:ss> | <nombre modelo> | <in_progress\|completed\|blocked\|partial> | <n/n> | <lista o N/A> | <lista o N/A> | <detalle o none> |

## Notas de columnas

- **Tiempo dedicado:** diferencia entre hora inicio y hora fin del paso, en minutos y segundos.
- **Checklist completado:** proporcion de items marcados frente al total del checklist de ese paso (ej. 5/5).
- **Skill usada:** nombre de las skills, instrucciones u otros recursos consultados o aplicados durante ese paso (ej. nombres de archivo o de skill); "N/A" si no se uso ninguno.
- **Artefactos generados:** rutas de archivos creados o actualizados durante ese paso.
- **Comentarios / Bloqueos:** gaps, decisiones relevantes o motivo de bloqueo; "none" si no aplica.
