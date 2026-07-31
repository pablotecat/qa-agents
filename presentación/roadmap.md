# Roadmap: próximos pasos

> Este proyecto tiene base para crecer. Cada agente nuevo cuesta menos que el anterior porque las piezas compartidas (handoff JSON, worklog, instrucciones generales, contratos) ya están parametrizadas.

Lo que sigue no es una promesa ni un backlog cerrado. Es un mapa de **dónde se puede explorar, probar y aportar**. Cada camino está abierto a quien quiera tomarlo.


---

## 1. Probarlos!

**Proyecto de prueba**

¿Hay algún sitio donde pueda probarlo? ¿Cómo sabemos si la skill aportó valor real al QA senior o solo ruido?

**Proyecto actual**

¿Qué cambios necesitan skills y agentes para encajar en nuestro proyecto en curso? ¿Qué ajustes a las rutas de salida o convenciones requiere nuestro repo?

---

## 2. Completar SDLC

**QA.automation**

¿Qué steps sigue un agente que convierte test cases markdown en código ejecutable (Playwright/Cypress/JUnit)? ¿Qué tools y skills necesita?

**QA.results-analysis**

¿Qué métricas extraemos de las pruebas ejecutadas y qué quiere el equipo que muestre el agente? ¿Dónde empieza y dónde termina su criterio de "información de calidad"?

**Otros Agentes**

¿Qué más agentes o skills ayudarían en nuestro trabajo QA diario? ¿Qué contrato (handoff) emitiría y consumiría cada uno?

---

## 3. Loop de mejora de skills

¿Qué mecanismo aplicamos para dar feedback al agente que se conviertan en propuestas concretas de mejora? ¿Quién decide cuándo una skill necesita revisión?

---

## 4. Orquestación

¿Merece la pena una orquestación automática, o nos quedamos como "directores" del pipeline?

---

### 5. MCP

¿A partir de qué nivel merece la pena construirlo? ¿Merece la pena un MCP con skills útiles de Testing para usar por todos?

---

## Cómo contribuir

1. **Elige un camino** de los anteriores.
2. **Antes de codear:** lee el `SKILL.md` correspondiente y los `steps/`. Si no entiendes el flujo, el problema es de la skill, no tuyo — mejórala.
3. **Prueba** antes de ampliar. Si una skill falla sistemáticamente en el mismo paso, ajústala; no añadas complejidad encima.
4. **Feedback del QA senior**, el criterio es si los artefactos son útiles para el trabajo real de QA.
5. **La unidad de extensión es el handoff, no el agente.** Solo añades un agente cuando hay un contract nuevo que emitir y otro que consumir.

---

## Lo que NO haríamos

- **No crear agentes para tareas humanas** (usabilidad, decisión sobre recursos, mediación DEV/PO, decisión de MVP).
- **No reintroducir orquestación automática sin evidencia.** Se fue con razón; el contrato handoff + decisión humana hace su función.
- **No versionar contracts (v1/v2 de handoff-schema) hasta necesitar breaking changes.** No hay consumidores externos que romper hoy.

---

## Pregunta abierta para el equipo

> ¿Por qué camino empezarías tú, y por qué?

No hay respuesta correcta única. La idea es que cada persona del equipo encuentre dónde su criterio de QA senior aporta más valor, y que ese aterrice en una skill, un agente o una tool.
