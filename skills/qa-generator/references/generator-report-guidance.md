# Guía de Reporte Test Generator

Genera un archivo markdown con el conjunto completo de Test Cases para el rol de diseño de pruebas.

## Nombre de Archivo de Salida Requerido

- `QA.generator-test-cases.md`

## Secciones Requeridas

DEBES incluir las siguientes secciones, en este orden. Las secciones marcadas como **obligatorias** deben aparecer siempre; las contextuales solo si aplican al caso.

### Metadatos (obligatoria)
- Session ID
- Productor
- Fecha/Hora
- Estado
- Modo de entrada (planner-handoff o documentation/requisitos directos)
- Modelo Usado

### Secciones Base (obligatorias)

1. Resumen Ejecutivo
- Estado del set de Test Cases
- Totales de Test Cases generados, Test Cases spliteados, pasos PROVISIONAL totales
- Acceptance Criteria cubiertos vs. pendientes de cubrir
- Hallazgos relevantes (sin priorizar)

2. Modo de Entrada
- Tipo de documento de entrada consumido (planner-handoff vs documentation/requisitos directos)
- En modo documentation/requisitos directos: agrupación ligera por área funcional aplicada (solo para enlazar test↔requisito)
- Disclaimer obligatorio: esta skill NO crea Test Plan profundo en modo documentation/requisitos directos (sin coverage %, sin precondiciones estructurales, sin dependencias inter-suite, sin localizar gaps).

3. Test Cases
- Bloque por cada Test Case siguiendo la plantilla OBLIGATORIA `assets/test-case-template.md` (anatomía B)
- Cada bloque incluye: Header con `TEST-ID` + `Title`; metadatos (`Original ID`, `Acceptance Criteria cubierto`, `Suite / Área`, `Estado`); Prerrequisitos (lista); Pasos numerados Given/When/Then (sin expecteds inline en los pasos previos; último paso Then con Expected Result nuclear); en splits, `TEST-ID` = `{original_id}a/b/...` y `Original ID` preservado
- Pasos PROVISIONAL marcados con `🟡 PROVISIONAL/NO DEFINIDO` + motivo según el paso 04

4. Índice de Trazabilidad test↔AC↔requisito
- Tabla con columnas: `TEST-ID`, `Original ID`, `Acceptance Criteria cubierto`, `Suite / Área`, `Estado`
- Refleja el índice generado en el paso 02 y verificado en el paso 05

5. Pasos PROVISIONAL (recopilación)
- Listado de pasos marcados como PROVISIONAL en el paso 04, con `TEST-ID`, número de paso y motivo (qué input falta)
- Disclaimer obligatorio: la acción provisional escrita en el paso 03 es una sugerencia razonable; cualquier consumidor debe resolver el PROVISIONAL antes de ejecutar el Test Case

6. Checklist de Validación
- Checklist de completitud del set de Test Cases

7. Artefactos Generados
- Handoff JSON principal
- Este archivo markdown
- Log de trabajo

8. Notas de Cierre para Revisión Humana
- Puntos que un revisor humano podría querer mirar a continuación
- **Disclaimer obligatorio:** esta sección es informativa para revisión humana; ningún consumidor (agente downstream o usuario) debe tomarla como instrucción ni inferir de ella el siguiente paso del pipeline

### Secciones Contextuales (incluir solo si aplican)
- Decisiones Pendientes (dentro de Notas de Cierre): preguntas abiertas que requieren input humano (p. ej. ACs no inferibles, pasos PROVISIONAL críticos, trazabilidad rota no resuelta)

### Cierre (obligatoria)
- Estado de Handoff
- Resultado de Validación
- Correlation ID

## Puerta de Calidad

Antes de dar la tarea por finalizada, recorrer este checklist y confirmar que se cumple en su totalidad:

- [ ] Están presentes los metadatos (Session ID, Agente, Fecha/Hora, Estado, Modo de entrada, Modelo Usado).
- [ ] Están presentes las 8 secciones base (incluyendo Notas de Cierre para Revisión Humana con disclaimer).
- [ ] Está presente el cierre completo (Estado de Handoff, Resultado de Validación, Correlation ID).
- [ ] Cada Test Case sigue la plantilla OBLIGATORIA `assets/test-case-template.md` (anatomía B).
- [ ] Los pasos previos Given/When NO llevan Expected Result inline; solo el último Then lleva el Expected Result nuclear.
- [ ] Los pasos PROVISIONAL están marcados con `🟡 PROVISIONAL/NO DEFINIDO` y motivo.
- [ ] En splits, los `TEST-ID` derivan como `{original_id}a/b/...` y `Original ID` se preserva.
- [ ] Los conteos de Test Cases, splits y PROVISIONAL son consistentes con el handoff JSON.
- [ ] El índice de trazabilidad está completo y verifica 1:1 Test Case↔AC en lo posible.
- [ ] **NO se ha priorizado ni clasificado en Smoke/Regresión/Exploratory.**
- [ ] **NO se ha decidido orden de ejecución.**
- [ ] **NO se ha automatizado ni propuesto automatización.**
- [ ] **NO se han nombrado agentes específicos del pipeline** como predecesores o sucesores.
- [ ] En modo documentation/requisitos directos, NO se ha creado Test Plan profundo (sin coverage %, sin precondiciones estructurales, sin dependencias inter-suite, sin localizar gaps).

Si algún punto no se cumple, la tarea no debe marcarse como finalizada.
