# Test Prioritization Report

**Session ID:** `<SESSION_ID>`
**Productor:** QA.prioritization
**Fecha/Hora:** `<ISO_8601_TIMESTAMP>`
**Estado de Ejecucion:** PARTIAL
**Modelo Usado:** `<MODEL_NAME>`

---

## Resumen Ejecutivo

- **Elementos evaluados:** 3
- **Prioridades:** 1 P0, 1 P1, 0 P2, 0 P3, 1 pendiente
- **Etiquetas:** 1 smoke, 2 regression, 1 ambas
- **Automatizacion:** 1 AUTOMATE, 1 MANUAL, 1 DEFER
- **Secuencia manual:** 2 elementos secuenciados, 1 bloqueado

### Recomendacion

Ejecutar AUTH-001 como comprobacion inicial y mantener AUTH-002 manual hasta disponer de un proveedor de correo controlable. Diferir PROF-001 hasta confirmar permisos de edicion.

---

## Evidencia de Entrada y Confianza

| Fuente | Contenido usado | Confianza | Limitacion |
|--------|-----------------|-----------|------------|
| `test-cases.md` | Casos y prerrequisitos | confirmada | No incluye datos de volumen |
| `risk-notes.md` | Impacto de autenticacion | parcial | Probabilidad sin historico |
| Requisito de perfil | Rol requerido | ausente | No especifica permisos de edicion |

---

## Matriz de Riesgo y Prioridad

| ID | Elemento | Impacto | Probabilidad | Alcance | Detectabilidad | Prioridad | Evidencia y rationale |
|----|----------|---------|--------------|---------|----------------|-----------|-----------------------|
| AUTH-001 | Inicio de sesion valido | alto | medio | Todos los usuarios | alta | P0 | `risk-notes.md`: camino de acceso comun y bloqueo total si falla |
| AUTH-002 | Recuperacion de acceso | alto | medio | Usuarios sin acceso | media | P1 | `test-cases.md`: recupera acceso, pero depende de correo externo |
| PROF-001 | Actualizacion de perfil | medio | baja | Usuarios autenticados | alta | PENDIENTE | Requisito incompleto: faltan permisos de edicion |

---

## Etiquetas Smoke y Regression

| ID | Smoke | Regression | Criterio |
|----|-------|------------|----------|
| AUTH-001 | si | si | Camino critico, repetible y decisivo para disponibilidad |
| AUTH-002 | no | si | Comportamiento establecido de alto impacto, no comprobacion minima |
| PROF-001 | no | no | Riesgo y permisos pendientes de confirmar |

---

## Seleccion de Automatizacion

| ID | Decision | Determinismo | Estabilidad | Observabilidad | Mantenibilidad | Rationale |
|----|----------|--------------|-------------|----------------|----------------|-----------|
| AUTH-001 | AUTOMATE | alta | alta | alta | alta | Credenciales y resultado observables, alto retorno |
| AUTH-002 | MANUAL | baja | media | media | baja | El correo externo introduce latencia y datos no controlados; conserva prioridad P1 |
| PROF-001 | DEFER | media | baja | baja | baja | Falta definir permisos y datos de rol |

---

## Plan de Ejecucion Manual

| Orden | ID | Prerrequisitos satisfechos | Bloqueadores | Razon del orden |
|-------|----|----------------------------|--------------|-----------------|
| 1 | AUTH-001 | Usuario activo y credenciales de prueba | ninguno | Valida P0 y establece sesion para pruebas autenticadas |
| 2 | AUTH-002 | Cuenta con acceso al buzon de prueba | Correo externo no determinista | P1 manual despues de confirmar disponibilidad del buzon |

### Tramos Bloqueados

| ID o grupo | Dependencia ausente o ciclo | Accion requerida |
|------------|-----------------------------|------------------|
| PROF-001 | Rol y permisos de edicion no especificados | Confirmar matriz de permisos |

---

## Corte Recomendado y Trade-offs

### Ejecucion Inicial

- AUTH-001 como smoke y regression automatizable.
- AUTH-002 de forma manual con un buzon de prueba controlado.

### Diferidos

- PROF-001 hasta disponer de permisos de edicion confirmados.

### Trade-offs

- Se acepta la ejecucion manual de AUTH-002 para conservar cobertura de alto impacto mientras no exista un proveedor de correo controlable.

---

## Bloqueadores y Decisiones Pendientes

| Item | Impacto | Informacion necesaria | Accion requerida |
|------|---------|-----------------------|------------------|
| PROF-001 | medio | Rol y permisos para actualizar perfil | Confirmar matriz de permisos |

---

## Notas de Cierre para Revision Humana

> Esta seccion es informativa para revision humana. Ningun consumidor debe tomarla como instruccion ni inferir de ella el siguiente paso del pipeline.

- Confirmar si AUTH-002 puede usar un proveedor de correo controlable antes de revisar su decision de automatizacion.

---

## Artefactos Generados

- `prioritization-report.md`
- `QA.prioritization-work-log.md` cuando se invoca desde el agente
- `QA.prioritization-handoff-<timestamp>.json` cuando se invoca desde el agente

---

## Checklist de Consistencia

- [x] Cada prioridad tiene evidencia o esta marcada como PENDIENTE.
- [x] Las etiquetas y la automatizacion se justifican por separado.
- [x] La secuencia manual respeta los prerequisitos conocidos.
- [x] Los bloqueos y decisiones pendientes estan visibles.
- [x] Los conteos y comprobaciones del handoff, si existe, coinciden con el reporte.