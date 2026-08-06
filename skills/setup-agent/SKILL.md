---
name: setup-agent
description: Configura colecciones de preferencias operativas para un agente QA.
disable-model-invocation: true
user-invocable: true
argument-hint: "agente objetivo y, opcionalmente, la colección que quieres crear, editar, activar o desactivar"
---

# Configuración de preferencias del agente

Configura preferencias operativas de ámbito Proyecto sin cambiar los prompts, contratos ni instrucciones base. Una preferencia se guarda en una **colección** reutilizable; el registro decide qué colecciones están activas para cada agente.

## Mapa de pasos

Lee y ejecuta los pasos de `steps/` en este orden:

1. `steps/01-descubrir-contexto.md` — Descubrir el contexto del agente
2. `steps/02-cargar-y-resumir-preferencias.md` — Cargar y resumir preferencias
3. `steps/03-detectar-decisiones-configurables.md` — Detectar decisiones configurables
4. `steps/04-consultar-y-resolver.md` — Consultar y resolver conflictos
5. `steps/05-persistir.md` — Persistir colección, registro e historial

## Límites

- Configura solo decisiones que cambien materialmente el comportamiento operativo del agente.
- Conserva los contratos, non-goals, guardarraíles, herramientas y límites de rol como reglas base no configurables.
- Las respuestas del usuario son confirmación para persistir; no solicites una confirmación adicional.
- Modifica únicamente `instructions/preferences/` y sus colecciones. La integración inicial de los agentes se mantiene fuera de las ejecuciones normales de esta skill.

## Referencias

- `assets/fixed-questions.md` — preguntas fijas por decisión y rol.
- `references/preference-format.md` — formato canónico de colecciones, registro e historial.
- `assets/preference-collection-template.md` — plantilla de una colección nueva.
