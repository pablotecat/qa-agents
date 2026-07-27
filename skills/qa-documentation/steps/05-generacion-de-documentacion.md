# Paso 5: Generacion de Reporte

## Objetivo del Paso

Generar el reporte markdown final del analisis y persistirlo correctamente, tras una revision de consistencia interna. Este paso produce el entregable principal del workflow.

## Modelo Recomendado

Usa el modelo de razonamiento mas potente disponible. Este paso produce el entregable final que otros agentes consumiran sin acceso a la fuente original: exige maxima precision y consistencia.

## Enfoque Exclusivo

Durante este paso tu ÚNICO objetivo es ensamblar, validar y persistir el entregable final.

## Resolución de output

Esta skill resuelve el directorio de salida (`output_dir`) así:

1. **Path explícito en la invocación**: si el usuario o el agente invocador indica un destino (patrones como `to <path>`, `save [to] <path>`, `en <path>`), úsalo como `output_dir`.
2. **Default**: en caso contrario o error, `output_dir` = `./qa-tmp/qa-documentation/<timestamp>/` (relativo al cwd del workspace; `<timestamp>` en ISO8601 compacto `YYYYMMDD-HHMMSS`).
3. Si el usuario pide explícitamente no generar documentación, en lugar de generarla escríbela en el chat.

### Artefactos a escribir (salvo que el usuario indique lo contrario)

- Reporte `QA.documentation-analysis-report.md` → en `output_dir`.
- Work-log `QA.documentation-work-log.md` → en `output_dir`.

## Secuencia

1. Genera `QA.documentation-analysis-report.md` siguiendo la guía `references/analysis-report-guidance.md` de esta skill.
2. Revisa la consistencia y trazabilidad internas del reporte (requisitos, gaps, agrupamiento por area, conteos por area/endpoint, estado del analisis).

## Restricciones operativas

- Trabaja sobre los requisitos, gaps y agrupamiento producidos en los pasos 01–04. Si detectas un faltante en este punto, regístralo como "decisión pendiente" en el reporte (sección Notas de Cierre) y continúa.
- La estructura y el nombre del reporte markdown: siguen la guía `references/analysis-report-guidance.md`.

## Checklist de completitud

- [ ] Se genero `QA.documentation-analysis-report.md` con el formato esperado.
- [ ] Los counts (req/gap/área/endpoint) del reporte son internamente consistentes y el estado del analisis queda reflejado en el reporte.
