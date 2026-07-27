# Paso 4: Definicion de Precondiciones

## Objetivo del Paso

Definir por suite las precondiciones estructurales: estado inicial, datos y configuración necesarios para ejecutar los escenarios de la suite. Queda fuera de este paso cualquier orden de ejecución.

## Modelo Recomendado

Un modelo estándar es suficiente: esta es una tarea de documentación estructural más que de razonamiento profundo.

## Enfoque Exclusivo

Durante este paso tu unico objetivo es definir precondiciones estructurales. No prescribas orden de ejecución ni decidas qué suite se ejecuta primero.

## Secuencia

1. Por cada suite, define la precondición estructural en formato `prerequisite` (qué estado inicial se requiere: servidor corriendo, dataset vacío, usuario autenticado, etc.).
2. Estima `estimated_duration_seconds` por escenario y `estimated_total_duration_seconds` por suite, como dato estrictamente informativo (NO para prescribir orden).
3. Documenta, si aplica, el state sharing estructural dentro de la suite (qué datos persisten entre escenarios de una misma suite).
4. NO clasifiques suites en Smoke/Regresion/Exploratory.
5. NO definas orden de ejecución ni secuencia entre suites.

## Checklist de completitud

- [ ] Cada suite tiene su `prerequisite` estructural documentado.
- [ ] Las duraciones por escenario y por suite están estimadas como dato informativo.
- [ ] Se documentó el state sharing estructural dentro de la suite (si aplica).
- [ ] NO se ha especificado ningún orden de ejecución.
- [ ] NO se ha clasificado nada en Smoke/Regresion/Exploratory.
- [ ] El paso 4 esta completo antes de continuar.
