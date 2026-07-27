# Plantilla OBLIGATORIA de Test Case (anatomía B)

Esta plantilla ES OBLIGATORIA. No es un ejemplo, es el formato que debe seguirse en `QA.generator-test-cases.md`.

Repite un bloque como el siguiente por cada Test Case. Sustituye los `<PLACEHOLDERS>` con valores reales.

---

### TEST-<ID>: <Title>

- **Original ID:** <original_id del documento de entrada | N/A (modo documentation/requisitos directos sin ID original)>
- **Acceptance Criteria cubierto:** <ref al AC del documento de entrada, p. ej. AC-001 o REQ-NNN>
- **Suite / Área:** <suite_id del planner | área funcional en modo documentation/requisitos directos>
- **Estado:** ✅ COMPLETED | 🟡 PROVISIONAL (ver pasos marcados abajo)

**Prerrequisitos**

- <Pre-condición 1: estado inicial, datos, configuración necesaria antes de ejecutar el Test Case.>
- <Pre-condición 2: ...>
- <(añadir más según convenga; puede estar vacío si el Test Case no requiere prerrequisitos especiales)>

**Pasos**

1. **Given** <estado inicial/contexto del paso.>
2. **When** <acción realizada por el usuario o sistema.>
3. **When** <acción adicional si la prueba lo requiere (pueden aparecer varios When).>
4. **Then** <verificación intermedia (opcional, si la necesitas).>
   🟡 **PROVISIONAL/NO DEFINIDO** — Motivo: <qué input falta del documento de entrada>. Acción provisional escrita: <acción razonable asumida>.
5. **Then** <verificación final del Test Case> → **Expected Result (nuclear):** <resultado nuclear del Test Case, redactado de forma observable y verificable.>

---

## Reglas de la plantilla (anatomía B)

1. **Header:** `### TEST-<ID>: <Title>` con el `TEST-ID` asignado. El `<Title>` puede renombrarse respecto al title del documento de entrada si describirá mejor el objetivo del Test Case (preservando siempre `Original ID`).

2. **Metadatos obligatorios:** `Original ID`, `Acceptance Criteria cubierto`, `Suite / Área`, `Estado`.
   - `Original ID` es el ID del documento de entrada (escenario del planner, p. ej. `registration_001`). En modo documentation/requisitos directos sin ID original, usar `N/A`.
   - En **splits**, `Original ID` se conserva con el valor original (p. ej. los Test Cases `registration_001a` y `registration_001b` ambos con `Original ID: registration_001`).

3. **Prerrequisitos:** lista. Estado inicial, datos y configuración necesarios antes de ejecutar el Test Case. Puede estar vacía si no aplica.

4. **Pasos numerados:** secuencia `Given` / `When` / `Then` (pueden aparecer varios pasos de cada tipo según la prueba).
   - Los pasos previos (`Given` y `When`) **NO llevan Expected Result inline**.
   - El **ÚLTIMO paso ES OBLIGATORIAMENTE un `Then`**.   
   
5. **Expected Result (nuclear)** es el resultado nuclear del Test Case. Es una sección aparte; no vive dentro del último paso. Es muy explícita con lo esperado del tests, es la comprobación atómica y nuclear de la prueba.

6. **Pasos PROVISIONAL:** Si un paso (incluido un Prerrequisito) no está claro por falta de definición en el documento de entrada, el marcaje explícito `🟡 PROVISIONAL` con motivo se incluye en el propio paso (lo decide el paso 04 del workflow). La acción provisional se escribe en el paso 03 del workflow.

7. **IDs en splits:** Si un escenario del documento de entrada se splitea en N Test Cases por cubrir N Acceptance Criteria:
   - `TEST-ID` deriva como `<original_id>a`, `<original_id>b`, ... (respetando el orden de los ACs).
   - `Original ID` se conserva con el valor `<original_id>` en todos los Test Case hijos.

8. **Prueba un único AC:** En la medida de lo posible, un Test Case prueba un único Acceptance Criteria. Si el documento de entrada cubre N ACs en un solo escenario, **splitear** en N Test Cases (regla 6).

9. **No priorizar, no clasificar, no automatizar:** la plantilla no incluye campos de prioridad, criticidad, tier (Smoke/Regresión/Exploratory) ni automatización. Esos son Non-goals de esta skill.

10. **No nombrar agentes del pipeline:** la plantilla no referencia predecesores ni sucesores específicos del pipeline. Solo hace trazabilidad al documento de entrada vía `Original ID` y `Acceptance Criteria cubierto`.
