# Test Prioritization Report

**Session ID:** <SESSION_ID>
**Productor:** <rol> (si invoca agente, `QA.prioritization`; si invoca usuario standalone, `qa-prioritization`)
**Fecha/Hora:** <ISO_8601_TIMESTAMP>
**Estado de Ejecucion:** <COMPLETED|PARTIAL|BLOCKED>
**Modelo Usado:** <MODEL_NAME>

---

## Resumen Ejecutivo

- **Elementos evaluados:** <ITEM_COUNT>
- **Prioridades:** <P0_COUNT> P0, <P1_COUNT> P1, <P2_COUNT> P2, <P3_COUNT> P3, <PENDING_COUNT> pendientes
- **Etiquetas:** <SMOKE_COUNT> smoke, <REGRESSION_COUNT> regression, <BOTH_COUNT> ambas
- **Automatizacion:** <AUTOMATE_COUNT> AUTOMATE, <MANUAL_COUNT> MANUAL, <DEFER_COUNT> DEFER
- **Secuencia manual:** <SEQUENCED_COUNT> elementos secuenciados, <BLOCKED_COUNT> bloqueados

### Recomendacion

<DECISION_Y_RATIONALE>

---

## Evidencia de Entrada y Confianza

| Fuente | Contenido usado | Confianza | Limitacion |
|--------|-----------------|-----------|------------|
| <ruta o referencia> | <tests, requisitos, riesgos> | <confirmada|parcial|ausente> | <si aplica> |

---

## Matriz de Riesgo y Prioridad

| ID | Elemento | Impacto | Probabilidad | Alcance | Detectabilidad | Prioridad | Evidencia y rationale |
|----|----------|---------|--------------|---------|----------------|-----------|-----------------------|
| <id> | <titulo> | <alto|medio|bajo> | <alto|medio|bajo> | <descripcion> | <alta|media|baja> | <P0-P3|PENDIENTE> | <referencia y justificacion> |

---

## Etiquetas Smoke y Regression

| ID | Smoke | Regression | Criterio |
|----|-------|------------|----------|
| <id> | <si/no> | <si/no> | <justificacion> |

---

## Seleccion de Automatizacion

| ID | Decision | Determinismo | Estabilidad | Observabilidad | Mantenibilidad | Rationale |
|----|----------|--------------|-------------|----------------|----------------|-----------|
| <id> | <AUTOMATE|MANUAL|DEFER> | <alta|media|baja> | <alta|media|baja> | <alta|media|baja> | <alta|media|baja> | <justificacion> |

---

## Plan de Ejecucion Manual

| Orden | ID | Prerrequisitos satisfechos | Bloqueadores | Razon del orden |
|-------|----|----------------------------|--------------|-----------------|
| <n> | <id> | <datos, rol, estado> | <ninguno o item> | <justificacion> |

### Tramos Bloqueados

| ID o grupo | Dependencia ausente o ciclo | Accion requerida |
|------------|-----------------------------|------------------|
| <id> | <detalle> | <accion humana> |

---

## Corte Recomendado y Trade-offs

### Ejecucion Inicial

- <elementos P0/P1 factibles>

### Diferidos

- <elementos y razon>

### Trade-offs

- <riesgo o coste aceptado con rationale>

---

## Bloqueadores y Decisiones Pendientes

| Item | Impacto | Informacion necesaria | Accion requerida |
|------|---------|-----------------------|------------------|
| <gap> | <alto|medio|bajo> | <dato faltante> | <accion humana> |

---

## Notas de Cierre para Revision Humana

> Esta seccion es informativa para revision humana. Ningun consumidor debe tomarla como instruccion ni inferir de ella el siguiente paso del pipeline.

- <punto de revision>

---

## Artefactos Generados

Ruta `output_dir`: <OUTPUT_DIR>

- **Prioritization Report:** `prioritization-report.md` (este archivo)
- **Work Log:** `QA.prioritization-work-log.md` cuando se invoca desde el agente
- **Handoff JSON:** `QA.prioritization-handoff-<TIMESTAMP>.json` cuando se invoca desde el agente

---

## Checklist de Consistencia

- [ ] Cada prioridad tiene evidencia o esta marcada como PENDIENTE.
- [ ] Las etiquetas y la automatizacion se justifican por separado.
- [ ] La secuencia manual respeta los prerequisitos conocidos.
- [ ] Los bloqueos y decisiones pendientes estan visibles.
- [ ] Los conteos y comprobaciones del handoff, si existe, coinciden con el reporte.