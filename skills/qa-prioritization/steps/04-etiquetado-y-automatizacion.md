# Paso 4: Etiquetado y Automatizacion

## Objetivo del Paso

Clasificar cada elemento para smoke, regression y automatizacion sin colapsar decisiones distintas en una sola etiqueta.

## Enfoque Exclusivo

Durante este paso no cambies la prioridad ni el contenido de los tests.

## Secuencia

1. Lee `references/prioritization-decision-guidance.md` y aplica sus criterios de etiquetas.
2. Asigna `smoke`, `regression`, ambas o ninguna; registra el criterio y la evidencia para cada etiqueta.
3. Evalua determinismo, estabilidad, observabilidad, coste, mantenibilidad y retorno para decidir `AUTOMATE`, `POSIBLE` o `MANUAL`.
4. Conserva una prueba manual de alto riesgo como prioritaria cuando su automatizacion no sea factible.
5. Registra los factores que deben cambiar para revisar una decision `POSIBLE`.

## Checklist de completitud

- [ ] Las etiquetas se justifican por separado de la automatizacion.
- [ ] Cada elemento tiene decision de automatizacion o limitacion documentada.
- [ ] Los elementos de alto riesgo manuales permanecen visibles.