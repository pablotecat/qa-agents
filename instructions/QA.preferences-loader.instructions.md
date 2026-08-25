---
name: QA Preferences Loader
description: "Carga las preferencias de Proyecto del agente QA antes de su workflow."
applyTo: "*/QA.*.agent.md"
---

# Cargador de preferencias QA

Cuando un agente QA vaya a iniciar su workflow, lee primero `instructions/preferences/<nombre-del-agente>.md`.

1. Localiza la sección `## Ajustes activos` del archivo del agente actual.
2. Si no contiene ajustes, continúa con las instrucciones base y el workflow.
3. Aplica cada ajuste activo junto a las instrucciones base.
4. Si el archivo contiene ajustes incompatibles o ambiguos para el mismo comportamiento, no inicies el workflow: presenta el conflicto al usuario y pide qué ajuste conservar, sustituir o reformular.

Las preferencias complementan las reglas base. Conserva objetivos, contratos, non-goals, guardarraíles, herramientas y requisitos de trazabilidad.
