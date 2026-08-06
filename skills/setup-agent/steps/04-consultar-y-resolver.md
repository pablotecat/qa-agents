# 04 — Consultar y resolver conflictos

## Acción

1. Presenta las preguntas fijas y dinámicas restantes con la decisión operativa que cambiarán.
2. Si hay conflicto entre colecciones activas, presenta primero una pregunta de resolución que nombre la decisión afectada y las alternativas incompatibles.
3. Solicita respuestas concretas, incluyendo si el usuario quiere crear, editar, activar o desactivar una colección existente.
4. Usa las respuestas del usuario como confirmación implícita de los cambios resultantes.
5. Si falta una respuesta necesaria para resolver un conflicto, detente sin modificar colecciones ni registro para esa decisión.

## Límite

No establezcas una precedencia automática entre colecciones incompatibles. No hagas preguntas cuya respuesta no alteraría el comportamiento operativo.

## Criterio de cierre

Cada cambio que se va a persistir cuenta con una respuesta explícita del usuario y no queda un conflicto sin resolver para la misma decisión.
