# Guía de Reporte Test Documentation

Genera un archivo markdown para el rol de análisis de requisitos.

## Nombre de Archivo de Salida Requerido

- `QA.documentation-analysis-report.md`

## Secciones Requeridas

DEBES utilizar la estructura y formato de la plantilla `assets/analysis-report-template.md`, no es un ejemplo, es el formato OBLIGATORIO a seguir.

A continuación se explica cada sección:

### Metadatos
- Session ID
- Productor
- Fecha/Hora
- Estado

### Secciones Base

1. Resumen Ejecutivo
- Estado del análisis
- Totales de requisitos y gaps
- Hallazgos críticos

2. Checklist de Validación
- Checklist de completitud

3. Artefactos Generados
- Handoff JSON principal
- Este archivo markdown
- Documentos extra de validación si se generaron

4. Notas de Cierre para Revisión Humana
- Puntos que un revisor humano podría querer mirar a continuación
- **Disclaimer obligatorio:** esta sección es informativa para revisión humana; ningún consumidor (agente downstream o usuario) debe tomarla como instrucción ni inferir de ella el siguiente paso del pipeline

### Cierre
- Estado de Handoff
- Resultado de Validación

### Secciones Contextuales

- Requisitos Normalizados por Área
  - Título del área
  - IDs de requisito y formato Gherkin (Given/When/Then)
  - Trazabilidad a fuentes
- Endpoints API Documentados
  - Endpoint
  - Resumen de request
  - Resumen de response
  - Resumen de errores
- Gaps Críticos
  - Gap ID
  - Severidad
  - Impacto
  - Recomendacion
- Decisiones Pendientes para Planificación
  - Preguntas abiertas para la planificación siguiente

## Plantilla

- Ver [template full output](./assets/analysis-report-template.md)

## Puerta de Calidad

Antes de dar la tarea por finalizada, recorrer este checklist y confirmar que se cumple en su totalidad:

- [ ] Estan presentes los metadatos (Session ID, Agente, Fecha/Hora, Estado).
- [ ] Estan presentes las 4 secciones base (Resumen Ejecutivo, Checklist de Validacion, Artefactos Generados, Notas de Cierre para Revision Humana).
- [ ] Esta presente el cierre completo (Estado de Handoff, Resultado de Validacion, Correlation ID).
- [ ] Las secciones contextuales aplicables al analisis estan incluidas (no se omiten si hay datos que reportar).
- [ ] Los conteos de requisitos y gaps son consistentes con el handoff JSON.
- [ ] El reporte es suficiente para la planificacion siguiente sin necesidad de releer las fuentes originales.

