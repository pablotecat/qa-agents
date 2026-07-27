# Paso 3: Modelamiento de Cobertura

## Objetivo del Paso

Mapear qué escenarios cubren qué requisitos, calcular porcentaje de cobertura por suite y total, e identificar dónde no hay cobertura relacionando con los gaps recibidos de documentation.QATesting.

## Modelo Recomendado

Usa un modelo con buena capacidad de razonamiento analítico. La calidad de este mapeo condiciona la decisión de cobertura pragmática que pueda tomarse si la cobertura no alcanza el 100%.

## Enfoque Exclusivo

Durante este paso tu unico objetivo es modelar cobertura. No diseñes nuevas suites ni definas precondiciones ni trazabilidad estructural.

## Secuencia

1. Mapea cada escenario a uno o varios requisitos origen (uno-a-uno o uno-a-muchos según corresponda).
2. Calcula `coverage_percentage` por suite y `coverage_percentage` total.
3. Identifica requisitos no cubiertos (`uncovered_requirements`) y relacionados con los gaps del handoff entrante.
4. Documenta qué gaps quedan mitigados por cobertura (`gaps_mitigated`) y cuáles no (`gaps_unmitigated`).
5. Si cobertura es imposible de alcanzar, marca GAP y deja registro para decisión posterior (ver sección "Manejo de Bloqueos y Retroalimentación" de SKILL.md).

## Checklist de completitud

- [ ] Cada escenario está mapeado a sus requisitos origen.
- [ ] Se calculó `coverage_percentage` por suite y total.
- [ ] Los requisitos no cubiertos están identificados y relacionados con gaps.
- [ ] `gaps_mitigated` y `gaps_unmitigated` están documentados como eco de documentation.QATesting.
- [ ] El paso 3 esta completo antes de continuar.
