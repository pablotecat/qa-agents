# Formato de preferencias de Proyecto

Esta referencia es la fuente canónica para las colecciones, el registro y el historial del MVP. Todo se guarda bajo `instructions/preferences/`.

## Colecciones

Ruta: `instructions/preferences/collections/<collection-id>.md`.

Cada colección tiene frontmatter:

```yaml
---
name: concise-and-actionable
description: "Controla la síntesis de reportes para agentes QA."
applyTo:
  - QA.documentation
  - QA.planner
---
```

- `name`: identificador único y estable de la colección.
- `description`: decisión operativa que controla.
- `applyTo`: lista de nombres de agente compatibles. Es metadato de selección interna; no es el mecanismo de auto-carga de VS Code.
- El cuerpo debe describir una decisión operativa y sus instrucciones. No almacena estado de activación.

## Registro activo

Ruta: `instructions/preferences/active-preferences.md`.

Mantiene una sección por agente. Cada entrada activa apunta a una ruta relativa de colección. Ejemplo:

```markdown
## QA.documentation

- `collections/concise-and-actionable.md`
```

Una colección se considera activa solo cuando aparece en la sección del agente. Antes de añadirla, comprueba que el `applyTo` de la colección contiene ese agente.

## Historial

Ruta: `instructions/preferences/preferences-history.md`.

Agrega una fila por modificación, con timestamp ISO 8601 real:

```markdown
| Timestamp | Agente | Colección | Cambio |
| --- | --- | --- | --- |
| 2026-08-06T10:15:00Z | QA.documentation | concise-and-actionable | Creada y activada |
```

No reescribas ni elimines entradas anteriores en el MVP.

## Conflictos

Dos colecciones entran en conflicto si dirigen de manera incompatible la misma decisión operativa para el mismo agente. El registro no debe dejar ambas activas sin una respuesta explícita del usuario. No se utiliza prioridad, orden de archivo ni antigüedad como desempate.

## Alcance del MVP

Solo existe el ámbito Proyecto. Los ámbitos Usuario, Sesión y Bajo demanda no tienen rutas ni precedencia en esta versión.
