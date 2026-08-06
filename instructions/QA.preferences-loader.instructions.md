---
name: QA Preferences Loader
description: "Carga las colecciones de preferencias de Proyecto activas para un agente QA antes de su workflow."
applyTo: "*/QA.*.agent.md"
---

# Cargador de preferencias QA

Cuando un agente QA vaya a iniciar su workflow, resuelve primero las preferencias de Proyecto.

1. Lee `instructions/preferences/active-preferences.md` y localiza la sección que coincide con el nombre del agente actual.
2. Si no hay colecciones activas, continúa con las instrucciones base y el workflow.
3. Por cada ruta activa, abre la colección correspondiente en `instructions/preferences/collections/` y comprueba que su frontmatter `applyTo` incluye al agente actual.
4. Aplica las instrucciones de las colecciones válidas junto a las instrucciones base.
5. Si dos colecciones activas dan directrices incompatibles o ambiguas para la misma decisión operativa, no inicies el workflow: presenta el conflicto al usuario y pide cuál debe permanecer activa.

Las preferencias complementan las reglas base. Conserva los objetivos, contratos, non-goals, guardarraíles, herramientas y requisitos de trazabilidad del agente cuando una colección esté activa.
