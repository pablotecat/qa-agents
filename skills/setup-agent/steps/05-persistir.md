# 05 — Persistir colección, registro e historial

## Acción

1. Consulta `../references/preference-format.md` y usa `../assets/preference-collection-template.md` al crear una colección.
2. Para una decisión nueva, crea una colección reutilizable en `instructions/preferences/collections/`. Para una existente, actualiza solo la colección indicada por el usuario.
3. Actualiza `instructions/preferences/active-preferences.md` para reflejar las colecciones activas del agente objetivo. No cambies el `applyTo` de una colección para activarla o desactivarla.
4. Añade una entrada cronológica con timestamp real en `instructions/preferences/preferences-history.md` por cada creación, edición, activación o desactivación.
5. Resume los cambios persistidos y las colecciones que permanecen activas.

## Puerta de calidad

Antes de cerrar, confirma todos los puntos:

- La colección tiene frontmatter Markdown válido, un `name` único, un `description` conciso y un `applyTo` compatible.
- El cuerpo contiene instrucciones operativas configurables, no cambios a reglas base.
- El registro no referencia archivos inexistentes ni colecciones incompatibles activas para la misma decisión.
- Cada modificación tiene exactamente una entrada nueva en el historial con fecha real, agente, colección y cambio.
- No se modificó ningún archivo fuera de `instructions/preferences/`.

## Criterio de cierre

Las preferencias acordadas, el registro de activación y el historial son coherentes entre sí y el usuario recibió un resumen de los cambios aplicados.
