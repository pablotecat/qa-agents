# QA Agents — Roadmap

> **Versión del paquete:** 2.1.0 · **Repositorio:** [pablotecat/qa-agent-creation](https://github.com/pablotecat/qa-agent-creation)

Este documento es la fuente canónica de features del proyecto `qa-agents`. Se organiza en lo ya realizado y tres horizontes temporales de futuro.

---

## Audiencia

| Icono | Perfil | Qué busca aquí |
|-------|--------|----------------|
| 👤 | **Usuarios** — equipos que instalan `qa-agents` en sus proyectos | Features disponibles, próximas funcionalidades, guía de adopción |
| 🛠 | **Contribuidores** — desarrolladores que extienden el sistema | Arquitectura, dependencias entre componentes, puntos de extensión |
---

## Cómo contribuir

1. **Elige un camino** de los horizontes de futuro.
2. **Antes de codear:** lee el `SKILL.md` correspondiente y los `steps/`. Si no entiendes el flujo, el problema es de la skill, no tuyo — mejórala.
3. **Prueba** antes de ampliar. Si una skill falla sistemáticamente en el mismo paso, ajústala; no añadas complejidad encima.
4. **Criterio del QA senior:** los artefactos deben ser útiles para el trabajo real de QA.
5. **La unidad de extensión es el handoff, no el agente.** Solo añades un agente cuando hay un contract nuevo que emitir y otro que consumir.

---

## Lo que NO se haría

- **No crear agentes para tareas humanas** (usabilidad, decisión sobre recursos, mediación DEV/PO, decisión de MVP).
- **No reintroducir orquestación automática sin evidencia.** Se fue con razón; el contrato handoff + decisión humana hace su función.
- **No versionar contracts** (`v1`/`v2` de `handoff-schema`) hasta necesitar breaking changes. No hay consumidores externos que romper hoy.
---

## ✅ Realizado

### Fase 1 — Fundación

| Feature | Descripción | Perfil |
|---------|-------------|--------|
| 4 agentes QA | `QA.documentation`, `QA.planner`, `QA.generator`, `QA.prioritization` — pipeline manual, cada uno `user-invocable` | 👤 🛠 |
| Pipeline manual con handoff JSON | Flujo de agente a agente vía handoff estructurado (`handoff-schema.json`). Decisión humana en cada transición. | 👤 🛠 |
| Sistema de sesiones | Estructura canónica en `tests/Documentation/sessions/` con subcarpetas por agente, session counter y manifest | 👤 🛠 |
| npm package | `qa-agents@2.1.0` — instalador que clona el repo y copia agentes, instrucciones, prompts, scripts y skills a `.github/` | 👤 |
| Script de timestamp | `scripts/current-time.mjs` — JSON con UTC, local, offset y timezone para worklogs | 🛠 |

### Fase 2 — Skills operativas

| Skill | Pasos | Referencias / Assets | Invocación |
|-------|-------|---------------------|------------|
| `qa-documentation` | 5 pasos | guía + template + ejemplo | Solo usuario |
| `qa-planner` | 6 pasos | guía + ejemplo | Solo usuario |
| `qa-generator` | 6 pasos | guía + template + ejemplo | Solo usuario |
| `qa-prioritization` | 6 pasos | 2 guías + template + ejemplo | Solo usuario |
| `qa-handoff-creation` | 5 pasos (inline) | spec + schema + ejemplo | Solo agente |
| `qa-worklog` | Inline | guía + template | Model-invocable |

### Fase 3 — Extensibilidad y estabilización

| Feature | Descripción | Perfil |
|---------|-------------|--------|
| `agent-preferences` | Calibración post-ejecución del comportamiento de cualquier agente QA. 5 pasos + reference. | 👤 🛠 |
| `playwright-best-practices` | Skill vendored (~50+ refs) — guía exhaustiva de Playwright para E2E, CI/CD, debugging, frameworks, etc. | 👤 🛠 |
| Migración orquestado → manual | Eliminación del modelo orquestado (rama `preserve/orchestration-model`). Pipeline manual con handoff como contrato entre agentes. | 🛠 |
| Contratos por agente | Cada agente tiene instruction con non-goals, owned-decisions y guardrails explícitos. Carga de preferencias integrada en instrucciones generales. | 🛠 |
| Bug fixes y quirks documentados | Handoff schema corregido, encoding UTF-8 en Windows, workarounds para quirks del wrapper | 🛠 |

---

## 🔵 Futuro inmediato — Próximas semanas

### 1. QA.automation

**Qué:** Agente que convierte test cases markdown en código ejecutable (Playwright, Cypress, JUnit, etc.).

**Por qué:** El pipeline actual genera artefactos documentales. El salto a código ejecutable cierra el ciclo entre planificación y ejecución automatizada.

**Dependencias:** `qa-generator` (formato de test cases), `playwright-best-practices` (guía de implementación).

| Aspecto | Detalle |
|---------|---------|
| Inputs | Test cases del `QA.generator` + `QA.proititization` (opcional) + contexto del proyecto |
| Outputs | Archivos de test ejecutables, reporte de generación |
| Skills nuevas | breve workflow para estandarizar con el resto de skills de agentes, simplemente para indicar la creación de los reports. En su trabajo usará directamente `playwright-best-practices` |
| Perfil | 👤 🛠 |

---

### 2. QA.manual-generator

**Qué:** Generador de tests manuales estructurados a partir de los test cases del `QA.generator`.

**Por qué:** No todos los tests se automatizan. Los tests manuales son necesarios para UX, exploratorios y escenarios que no encajan en automatización.

**Dependencias:** `qa-generator` (formato de entrada).

| Aspecto | Detalle |
|---------|---------|
| Inputs | Test cases del `QA.generator` + `QA.proititization` (opcional) |
| Outputs | Documento de tests manuales con pasos detallados |
| Skills nuevas | `qa-manual-generator` (workflow) |
| Perfil | 👤 🛠 |

---

### 3. Skills de exportación a formatos

**Qué:** Skills que transforman los artefactos QA (test cases, reportes, priorizaciones) a formatos consumibles por herramientas de gestión.

**Formatos objetivo:**

| Formato | Caso de uso | Perfil |
|---------|-------------|--------|
| Excel (.xlsx) | Compartir con stakeholders no técnicos | 👤 |
| CSV | Importar a herramientas genéricas | 👤 |
| Formato Jira/Xray | Importar test cases en Jira/Xray | 👤 |
| Formato Azure DevOps | Importar test cases como work items en Azure Boards | 👤 |

**Dependencias:** Artefactos de cualquier agente QA (se consumen los outputs markdown/JSON).

---

### 4. Skills de conexión con Azure DevOps y Jira

**Qué:** Integración API bidireccional para sincronizar artefactos QA con plataformas de gestión de proyectos.

**Por qué:** Los equipos ya trabajan en Azure/Jira. Copiar resultados manualmente es frágil y lento. La conexión API permite push/pull de test cases, resultados de ejecución y trazabilidad.

**Dependencias:** Skills de exportación (formato) + credenciales/configuración del proyecto destino.

| Aspecto | Detalle |
|---------|---------|
| Azure DevOps | Push de test cases a test plans, actualización de resultados de ejecución |
| Jira/Xray | Creación de test issues, sincronización de estados |
| Config | Variables de entorno o `.github/qa-connections.json` |
| Perfil | 👤 🛠 |

---

## 🟡 Medio plazo — 1-3 meses

### 5. Loop de mejora

**Qué:** Mecanismo de feedback que convierte observaciones post-ejecución en propuestas concretas de mejora de skills y agentes.

**Cómo funciona:**
1. El usuario ejecuta un agente y observa resultados.
2. Usa `agent-preferences` para ajustes operativos (ya existe).
3. Un nuevo mecanismo captura patrones recurrentes y propone cambios estructurales en steps/references.

**Dependencias:** `agent-preferences` (base existente), historial de sesiones.

| Aspecto | Detalle |
|---------|---------|
| Inputs | Sesiones previas, preferencias acumuladas, feedback del QA senior |
| Outputs | Propuestas de cambio en SKILL.md, steps, references |
| Skills nuevas | `qa-improvement` o extensión de `agent-preferences` |
| Perfil | 🛠 |

---

### 6. Orquestación

**Qué:** Evaluar si la orquestación automática aporta valor frente al pipeline manual actual.

**Contexto:** El modelo orquestado se eliminó deliberadamente. El handoff JSON + dirección humana funciona. La pregunta es si existe un punto donde la automatización del routing justifique la complejidad añadida.

**Criterio de decisión:** Solo reintroducir si hay evidencia de que los humanos están haciendo routing trivial y repetitivo que el sistema puede resolver sin pérdida de calidad.

**Dependencias:** Datos de uso real del pipeline manual (cuántas sesiones, patrones de routing, errores humanos).

| Aspecto | Detalle |
|---------|---------|
| Inputs | Métricas de uso del pipeline manual |
| Outputs | Decisión: mantener manual / reintroducir orquestación parcial |
| Perfil | 🛠 |

---

### 7. Integración CI/CD

**Qué:** Pipeline automatizado que genere y ejecute tests como parte del flujo de integración continua.

**Por qué:** Actualmente la generación es manual (el usuario invoca agentes). La integración CI/CD permite que cambios en el código disparen automáticamente la regeneración de test cases y la ejecución de tests automatizados.

**Dependencias:** `QA.automation` (código ejecutable), `QA.automation` + skills de conexión (reportar resultados).

| Aspecto | Detalle |
|---------|---------|
| Trigger | Push a rama, PR, schedule |
| Flujo | Detección de cambios → regeneración de tests → ejecución → reporte |
| Plataformas | GitHub Actions, Azure Pipelines, GitLab CI |
| Perfil | 👤 🛠 |

---

## 🔴 Largo plazo — 3+ meses

### 8. Autodetección de cambios en PR

**Qué:** Agente que analiza diffs de un PR y determina qué tests deben actualizarse, crearse o eliminarse.

**Por qué:** Cuando el código cambia, los tests correspondientes quedan desactualizados. La detección automática mantiene la cobertura alineada con el código sin intervención manual.

**Dependencias:** `QA.automation` + integración CI/CD + análisis semántico de código.

| Aspecto | Detalle |
|---------|---------|
| Inputs | Diff del PR, test cases existentes, código fuente |
| Outputs | Lista de tests a actualizar/crear/eliminar, test cases modificados |
| Skills nuevas | `qa-change-detector`, `qa-test-updater` |
| Perfil | 👤 🛠 |

---

### 9. Marketplace de skills QA

**Qué:** Ecosistema donde terceros publiquen y consuman skills QA reutilizables.

**Por qué:** Las skills son la unidad de extensión del sistema. Un marketplace permite que la comunidad aporte integraciones (nuevos frameworks, plataformas, formatos) sin centralizar todo en el repo principal.

**Dependencias:** Masa crítica de skills, mecanismo de distribución (npm, GitHub,_skills.sh_), estándares de calidad y compatibilidad.

| Aspecto | Detalle |
|---------|---------|
| Formato | Skills compatibles con `skills add` (ya soportado por el instalador) |
| Calidad | Checklist de validación, ejemplos requeridos |
| Distribución | Integración con [skills.sh](https://skills.sh) o registry propio |
| Perfil | 👤 🛠 |

