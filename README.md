# qa-agents

Paquete npm que instala los **agentes QA de GitHub Copilot** en cualquier proyecto. El runtime no va dentro del paquete: el binario lo **descarga desde GitHub** (`pablotecat/qa-agents`) en cada ejecución. Los agentes, skills, instrucciones y prompts quedan en `.github/`, listos para ser invocados desde Copilot.

## Instalación

### Modo 1 — Runner completo (recomendado para el pipeline QA)

Instala todo el runtime en `.github/` (overwrite forzado, idempotente, sin confirmación interactiva):

```bash
npx qa-agents
```

### Modo 2 — Solo skills (estándar del ecosistema `skills`)

Instala únicamente las carpetas con `SKILL.md`. No instala `.agent.md`, `.instructions.md` ni `prompts/`:

```bash
npx skills add pablotecat/qa-agents
```

## Estructura Agente
```mermaid
%%{init: {'theme': 'dark', 'themeVariables': { 'background': '#000000', 'primaryColor': '#1F4E79', 'edgeLabelBackground':'#000000', 'tertiaryColor': '#222', 'lineColor': '#FFFFFF', 'textColor': '#FFFFFF' }}}%%
flowchart TB
  %% ===== Estilos con alto contraste sobre fondo negro =====
  classDef agent fill:#1F4E79,color:#FFFFFF,stroke:#5B9BD5,stroke-width:2px,font-weight:bold
  classDef skill fill:#C55A11,color:#FFFFFF,stroke:#F4B183,stroke-width:2px,font-weight:bold
  classDef instr fill:#E2EFDA,color:#000000,stroke:#70AD47,stroke-width:2px
  classDef prompt fill:#FBE5D6,color:#000000,stroke:#ED7D31,stroke-width:2px
  classDef out fill:#006D77,color:#FFFFFF,stroke:#83C5BE,stroke-width:2px,font-weight:bold

  Usr(["Usuario"]):::agent
  P["Prompt<br/>test-documentation-init"]:::prompt
  Doc["Agente<br/>QA.documentation"]:::agent

  subgraph ins["Instrucciones"]
    direction LR
    I1["general"]:::instr
    I2["contrato agente"]:::instr
  end

  subgraph sks["Skills"]
    direction LR
    S1["qa-documentation"]:::skill
    S2["qa-worklog"]:::skill
    S3["qa-handoff-creation"]:::skill
  end

  subgraph outs["Salidas"]
    direction LR
    O1["analysis-report.md<br/>(contenido)"]:::out
    O2["work-log.md<br/>(traza)"]:::out
    O3["handoff-{ts}.json<br/>(recibo)"]:::out
  end

  Usr -->|slash command| P
  P -->|inicia| Doc
  ins -. aplica a .-> Doc
  Doc -->|ejecuta| sks
  S1 -->|genera| O1
  S2 -->|genera| O2
  S3 -. genera (opcional) .-> O3

  %% ===== Bordes y aristas en blanco para alto contraste sobre negro =====
  classDef subg fill:#1A1A1A,color:#FFFFFF,stroke:#FFFFFF,stroke-width:2px
  class ins,sks,leg,outs subg
  linkStyle default stroke:#FFFFFF,color:#FFFFFF,font-weight:bold
```

## Estructura Skill
```mermaid
%%{init: {'theme': 'dark', 'themeVariables': { 'background': '#000000', 'primaryColor': '#1F4E79', 'edgeLabelBackground':'#000000', 'tertiaryColor': '#222', 'lineColor': '#FFFFFF', 'textColor': '#FFFFFF' }}}%%
flowchart LR
  %% ===== Estilos con alto contraste sobre fondo negro =====
  classDef skill fill:#C55A11,color:#FFFFFF,stroke:#F4B183,stroke-width:2px,font-weight:bold
  classDef file fill:#FFF4D6,color:#000000,stroke:#FFC000,stroke-width:1px
  classDef out fill:#006D77,color:#FFFFFF,stroke:#83C5BE,stroke-width:2px,font-weight:bold
  classDef input fill:#E2EFDA,color:#000000,stroke:#70AD47,stroke-width:2px
  classDef section fill:#1A1A1A,color:#FFFFFF,stroke:#FFFFFF,stroke-width:2px

  Input["Fuentes:<br/>specs · docs · API<br/>flujos de UI"]:::input

  subgraph skill["Skill qa-documentation"]
    direction TB
    SK["SKILL.md<br/>(mapa y reglas)"]:::skill
    subgraph steps["steps/ (en orden)"]
      direction LR
      S1["01<br/>extracción<br/>de requisitos"]:::file
      S2["..."]:::file
      S5["05<br/>generación<br/>de reporte"]:::file
    end
    Guidance["references/<br/>analysis-report-guidance.md"]:::file
    SK --> steps
    S1 --> S2 --> S5
  end

  Output["analysis-report.md<br/>(contenido)"]:::out

  Input -->|lee| S1
  S5 -->|sigue guía| Guidance
  S5 -->|genera| Output

  %% ===== Estilo de subgrafos =====
  class skill,steps section
  linkStyle default stroke:#FFFFFF,color:#FFFFFF,font-weight:bold
```
## Invocación

Cada skill de workflow produce su reporte markdown de forma autónoma. El handoff JSON y el worklog son **opcionales** y lo gestiona el invocador (agente o usuario) vía `qa-worklog` y `qa-handoff-creation` respectivamente.

- **Vía agente** (pipeline QA): isntala el paquete entero y llama al agente. Éste gestiona el worklog y handoff. Artefactos en `./tests/Documentation/sessions/`.
- **Vía skill standalone** (sin agente): slash command directo. Devuelve el reporte markdown sin handoff ni worklog. Artefactos en `./.qa-tmp/<skill-name>/<timestamp>/`, por defecto.

### Ruta de salida en modo standalone

1. `to <path>` (o `save [to] <path>`, `en <path>`) → escribe ahí.
2. `preview` o `no-save` → chat-only, nada en disco.
3. Default → `./qa-tmp/<skill-name>/<timestamp>/` (relativo al cwd).

Bajo `./tests/Documentation/sessions/`, cada agente crea su subcarpeta `QA-{agente}-agent/`. El primer agente en ejecutarse inicializa la carpeta de sesión y el contador.

## Estructura del paquete npm

El paquete publicado solo contiene binario y README; el runtime se descarga de GitHub en cada ejecución:

```text
.
├── bin/install.mjs     # binario ESM (Node ≥16.7, fs.cpSync) expuesto como `qa-agents`
├── package.json        # name: qa-agents, files: [bin/, README.md]
└── README.md
```

El campo `files` en `package.json` garantiza que el tarball incluya **solo** `bin/` y `README.md`. Las carpetas runtime (`agents/`, `instructions/`, `prompts/`, `skills/`) **no se publican** pero **deben existir en el repo de GitHub** porque es lo que descarga el bin.
