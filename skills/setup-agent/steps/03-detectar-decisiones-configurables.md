# 03 — Detectar decisiones configurables

## Acción

1. Lee `../assets/fixed-questions.md` y selecciona solo las preguntas aplicables al agente objetivo que no estén cubiertas por colecciones activas.
2. Deriva preguntas dinámicas únicamente si el rol contiene una decisión operativa relevante sin preferencia vigente.
3. Para cada pregunta candidata, verifica la prueba de materialidad: respuestas diferentes deben cambiar una acción, el formato de una salida o la interacción con el usuario.
4. Justifica cada pregunta dinámica con el aspecto concreto del rol o de su flujo que cambiaría.
5. Elimina preguntas redundantes, aleatorias, meramente informativas o que intenten alterar una regla base.

## Ejemplos de decisiones configurables

- Nivel de detalle de un resumen que el agente ya debe producir.
- Umbral para pedir aclaración cuando el rol permite continuar documentando un gap o una provisionalidad.
- Forma de presentar decisiones pendientes al usuario.

## Criterio de cierre

Toda pregunta pendiente pasa la prueba de materialidad, es aplicable al rol y no duplica una preferencia activa ni una pregunta fija ya cubierta.
