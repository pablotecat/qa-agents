# Testing es responsabilidad de todo el equipo

El objetivo de QA no es "testear al final", sino acompañar el ciclo completo: defectos detectados en requisitos cuestan $1; en producción cuestan $1000+.

```mermaid
flowchart TD
    classDef sdlc fill:#2563eb,color:#ffffff,stroke:#60a5fa,stroke-width:2px
    classDef qa   fill:#10b981,color:#000000,stroke:#6ee7b7,stroke-width:2px
    classDef prod fill:#f59e0b,color:#ffffff,stroke:#fcd34d,stroke-width:2px

    %% ===== Fases del SDLC =====
    R["📋 1. Requisitos<br/>Requirements"]:::sdlc
    P["🧭 2. Planificación<br/>Planning"]:::sdlc
    D["📐 3. Diseño<br/>Design"]:::sdlc
    V["💻 4. Desarrollo<br/>Implementation"]:::sdlc
    T["🧪 5. Testing<br/> e Integración"]:::sdlc
    DE["🚀 6. Despliegue<br/>Deployment"]:::sdlc
    M["🛠️ 7. Mantenimiento<br/>Maintenance"]:::sdlc

    R --> P --> D --> V --> T --> DE --> M
    M -. retroalimentación .-> R

    %% ===== Estilo de flechas (claras sobre fondo oscuro) =====
    linkStyle 0 stroke:#e5e7eb,stroke-width:2px,color:#e5e7eb
    linkStyle 1 stroke:#e5e7eb,stroke-width:2px,color:#e5e7eb
    linkStyle 2 stroke:#e5e7eb,stroke-width:2px,color:#e5e7eb
    linkStyle 3 stroke:#e5e7eb,stroke-width:2px,color:#e5e7eb
    linkStyle 4 stroke:#e5e7eb,stroke-width:2px,color:#e5e7eb
    linkStyle 5 stroke:#e5e7eb,stroke-width:2px,color:#e5e7eb
    linkStyle 6 stroke:#fbbf24,stroke-width:2px,color:#fbbf24,stroke-dasharray:5 5

    %% ===== Actividades de QA por fase =====
    QR["✅ QA: revisión de requisitos<br/>• Análisis de aceptabilidad<br/>• Gaps y ambigüedades<br/>• Definición de criterios de aceptación"]:::qa
    QP["✅ QA: estrategia de pruebas<br/>• Plan de pruebas<br/>• Cobertura y riesgos<br/>• Entorno y datos"]:::qa
    QD["✅ QA: diseño de pruebas<br/>• Casos de prueba<br/>• Trazabilidad req↔test<br/>• Datos y entorno"]:::qa
    QV["✅ QA: automatización<br/>• Scripts de prueba<br/>• Pruebas unitarias/integración<br/>• Revisiones de código"]:::qa
    QT["✅ QA: ejecución<br/>• Ejecución de suites<br/>• Reporte y triaje de defectos<br/>• Pruebas de regresión"]:::qa
    QDE["✅ QA: validación de release<br/>• Smoke tests en producción<br/>• Verificación de despliegue<br/>• Criterio de salida (Go/No-Go)"]:::qa
    QM["✅ QA: monitoreo post-release<br/>• Métricas en producción<br/>• Hotfixes y parches<br/>• Lecciones aprendidas"]:::qa

    R -.- QR
    P -.- QP
    D -.- QD
    V -.- QV
    T -.- QT
    DE -.- QDE
    M -.- QM
```

## ¿Qué validaciones debe seguir haciendo el humano? 

- Corregir y completar escenarios
- Decisiones de tiempos y recursos disponibles (Qué se puede ejecutar, qué tiene sentido automatizar)
- Testing de aspectos subjetivos de la aplicación (usabilidad, A11y, UI/UX, tono...)
- Falsos positivos y negativos
- Comunicación y mediación DEV/PO

