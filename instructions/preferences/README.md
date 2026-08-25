# Preferencias de Proyecto

Esta carpeta contiene la capa configurable de instrucciones para los agentes QA. Las preferencias complementan las instrucciones base: no reemplazan contratos, guardarraíles, non-goals ni objetivos de los agentes.

## Contenido

- `QA.documentation.md`, `QA.generator.md` y `QA.planner.md` contienen los ajustes activos de cada agente.
- `preferences-history.md` conserva el historial cronológico de cambios.

El cargador [QA.preferences-loader.instructions.md](../QA.preferences-loader.instructions.md) lee el archivo del agente antes de su workflow.

## Ámbito

El MVP solo admite preferencias de Proyecto. Gestiona cambios mediante `setup-agent` después de una ejecución concreta: aporta el agente, la carpeta de sesión y feedback sobre el comportamiento que quieres ajustar. La skill presenta el texto exacto y solo escribe tras aprobación explícita.

> Una reinstalación forzada de `qa-agents` copia el runtime completo y puede sobrescribir esta carpeta. Conserva una copia antes de reinstalar si necesitas preservar preferencias locales.
