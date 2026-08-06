# Preferencias de Proyecto

Esta carpeta contiene la capa configurable de instrucciones para los agentes QA. Las preferencias complementan las instrucciones base: no reemplazan contratos, guardarraíles, non-goals ni objetivos de los agentes.

## Contenido

- `collections/` contiene colecciones reutilizables de instrucciones operativas.
- `active-preferences.md` indica qué colecciones están activas por agente.
- `preferences-history.md` conserva el historial cronológico de cambios.

El cargador [QA.preferences-loader.instructions.md](../QA.preferences-loader.instructions.md) resuelve el registro antes del workflow de cada agente QA.

## Ámbito

El MVP solo admite preferencias de Proyecto. Gestiona esta carpeta mediante la skill `setup-agent`; no actives colecciones editando sus propios `applyTo`.

> Una reinstalación forzada de `qa-agents` copia el runtime completo y puede sobrescribir esta carpeta. Conserva una copia antes de reinstalar si necesitas preservar preferencias locales.
