---
name: qa-documentation
description: Extrae, normaliza y entrega requisitos QA consolidados en un analysis-report markdown.
disable-model-invocation: true
argument-hint: "solicitud QA y fuentes de requisitos. Opcional: 'to <path>' para destino, o 'preview'/'no-save' para chat-only."
compatibility: 
  - agents: [QA.documentation]
---

Workflow de documentación QA: extrae, normaliza y entrega requisitos consolidados en un reporte markdown.

## Mapa de pasos

DEBES leer y ejecutar los pasos en orden:

`01 Extracción de Requisitos` → `02 Identificación de Gaps` → `03 Particionado por Área` → `04 Normalización y Estructuración` → `05 Generación de Reporte`

## Feedback al usuario

- Mientras ejecutas cada paso: salvo que el usuario indique lo contrario, escribe en el chat solo para reportar errores o decisiones pendientes; de lo contrario, mantén silencio.
- Cuando termines cada paso: responde en chat **exactamente una línea seca** con el formato `<nombre-del-paso> OK.`
- Cuando termines de escribir archivos: responde en chat **exactamente una línea seca** con el formato `<nombre-del-workflow> OK; reporte: <ruta a archivos generados>`;

