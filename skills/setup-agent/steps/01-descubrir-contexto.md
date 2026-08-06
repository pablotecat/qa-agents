# 01 — Descubrir el contexto del agente

## Acción

1. Identifica el agente objetivo.
2. Lee su archivo en `agents/` y su contrato correspondiente en `instructions/`.
3. Lee `instructions/QATesting-general.instructions.md`, `instructions/QA.preferences-loader.instructions.md` e `instructions/preferences/README.md`.
4. Localiza `instructions/preferences/active-preferences.md`, `instructions/preferences/preferences-history.md` y las colecciones de `instructions/preferences/collections/`.
5. Construye una lista de decisiones que el rol puede adaptar sin alterar una regla base.

## Límite

Trata como no configurables los objetivos del agente, non-goals, owned decisions, guardarraíles, herramientas, rutas de workflow y requisitos de trazabilidad. No analices errores propios ni propongas correcciones de las instrucciones base.

## Criterio de cierre

El agente objetivo, sus reglas base y los archivos de preferencias existentes están identificados; cada posible decisión candidata pertenece al comportamiento operativo y no contradice una regla base.
