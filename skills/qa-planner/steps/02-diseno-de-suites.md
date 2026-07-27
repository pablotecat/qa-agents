# Paso 2: Diseno de Suites

## Objetivo del Paso

Agrupar los requisitos y escenarios comprendidos en el Paso 1 en suites lógicas cohesivas por área funcional, definiendo identificador, nombre, descripción, complejidad y dependencias inter-suite estructurales (no orden de ejecución).

## Modelo Recomendado

Usa un modelo con buena capacidad de razonamiento y estructuración. La cohesión de cada suite condiciona la trazabilidad y la cobertura que se modelarán después.

## Enfoque Exclusivo

Durante este paso tu unico objetivo es diseñar suites cohesivas. No modeles cobertura todavía, ni definas precondiciones ni trazabilidad.

## Secuencia

1. Agrupa los requisitos en suites por área funcional (ej: "Auth Suite", "Registration Suite").
2. Define cada suite con: `suite_id`, `name`, `description`, `complexity` (LOW/MEDIUM/HIGH), y lista de `requirements` origen.
3. Define los escenarios dentro de cada suite: cada escenario es el NOMBRE de un test (`id`, `title`), no una secuencia de pasos.
4. Lista las dependencias inter-suite estructurales (`suite_dependencies`): qué suite depende de qué (sin prescribir orden de ejecución).
5. Estima `estimated_total_duration_seconds` por suite como dato estrictamente informativo (no se usa para decidir orden).

## Checklist de completitud

- [ ] Las suites son cohesivas por área funcional.
- [ ] Cada suite tiene `suite_id` único, `name`, `description`, `complexity` y lista de `requirements` origen.
- [ ] Cada escenario dentro de una suite es un NOMBRE de test (sin pasos).
- [ ] Las dependencias inter-suite estructurales están mapeadas (sin prescribir orden).
- [ ] El paso 2 esta completo antes de continuar.
