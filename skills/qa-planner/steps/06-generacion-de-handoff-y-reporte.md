# Paso 6: Generacion de Reporte

## Objetivo del Paso

Generar el reporte markdown `QA.planner-execution-summary.md` y persistirlo correctamente.

## Modelo Recomendado

Usa el modelo de razonamiento mas potente disponible. Este paso produce el entregable final que otros agentes consumiran sin acceso a la fuente original: exige maxima precision y consistencia.

## Enfoque Exclusivo

Durante este paso tu unico objetivo es ensamblar, validar y persistir el entregable final. No diseñes nuevas suites ni replantees cobertura, precondiciones o trazabilidad.

## Secuencia

1. Genera `QA.planner-execution-summary.md` siguiendo la guía `references/planner-report-guidance.md` de esta skill.
2. Revisa la consistencia y trazabilidad internas del reporte (suites, escenarios, requisitos cubiertos, porcentaje de cobertura, estado del plan): `work_performed`, `checks`, `counts` deben ser internamente consistentes en el markdown.

## Checklist de completitud

- [ ] Se generó `QA.planner-execution-summary.md` con el formato esperado por la guía.
- [ ] Los counts (suites/escenarios/requisitos cubiertos/porcentaje de cobertura) del reporte son internamente consistentes y el estado del plan queda reflejado en el reporte.
- [ ] El paso 6 esta completo y el workflow puede cerrarse.
