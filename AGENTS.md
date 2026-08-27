# AGENTS.md

<!-- Guía de referencia rápida para cualquier agente de código que trabaje en este repositorio.
     El runtime publicado NO se desarrolla aquí como código fuente: este repo define agentes,
     skills e instrucciones en markdown que el binario installa en otros proyectos vía
     `npx qa-agents` (clonación shallow desde GitHub). Trátalo como un paquete "content + installer". -->

## Project Overview

`qa-agents` es un paquete npm (v2.1.1) que instala los **agentes QA de GitHub Copilot** en cualquier proyecto consumidor. El runtime no se empaqueta dentro del tarball: el binario `bin/install.mjs` hace un `git clone --depth 1` del repo `pablotecat/qa-agent-creation` y copia los directorios runtime a `<cwd>/.github/`.

El paquete está pensado para distribuirse por dos vías:

1. **Runner completo** → `npx qa-agents` (instala agentes + instrucciones + prompts + scripts + skills en `.github/`).
2. **Solo skills** → `npx skills add pablotecat/qa-agents` (estándar del ecosistema `skills`; solo carpetas con `SKILL.md`).

### Stack y arquitectura

- **Node.js ESM** (≥16.7, requiere `fs.cpSync`). El binario no usa dependencias npm externas: solo módulos nativos (`node:fs`, `node:child_process`, `node:os`, `node:path`).
- **PowerShell 5.1** para el script de instalación del MCP de Azure DevOps.
- **Contenido runtime en markdown** con frontmatter YAML: agentes (`.agent.md`), skills (`SKILL.md` + `steps/` + `references/`), instrucciones (`.instructions.md` con `applyTo`) y prompts (slash commands).

### Estructura del repo

```text
.
├── bin/install.mjs              # binario ESM expuesto como `qa-agents`; clona y copia el runtime
├── package.json                 # name=qa-agents, files=[bin/, README.md], sideEffects=false
├── agents/                      # agentes QA (.agent.md con frontmatter YAML)
├── instructions/                # instrucciones operativas (.instructions.md con applyTo)
│   └── preferences/             # historial y README de preferencias calibradas
├── prompts/                     # slash commands (.md)
├── skills/                      # skills de workflow + transversales (SKILL.md + steps/ + references/)
├── scripts/                     # utilidades: current-time.mjs, install-ado-mcp.ps1
├── presentación/                # docs auxiliares en español (roadmap, diagramas, links)
├── new-skill.md                 # tarea viva: creación de skill azdevops-test-management
├── roadmap.md                   # fuente canónica de features (realizado + horizontes)
├── skills-lock.json             # lock de skills externas (create-agentsmd, writing-for-agents)
├── README.md                    # documentación de usuario (instalación y uso del runtime)
└── AGENTS.md                    # esta guía (contexto para agentes de código)
```

> Importante: el campo `files` en `package.json` garantiza que el tarball publicado contenga **solo** `bin/` y `README.md`. Las carpetas runtime (`agents/`, `instructions/`, `prompts/`, `scripts/`, `skills/`) **no se publican** pero **deben existir en el repo de GitHub** porque son lo que descarga el binario en cada ejecución.

## Setup Commands

### Requisitos

- **Node.js ≥16.7** (uso de `fs.cpSync`).
- **Git** en el PATH (el instalador hace shallow clone).
- Para el script de MCP de Azure DevOps: **PowerShell 5.1** (Windows).

### Instalación de dependencias

Este repositorio no tiene dependencias npm runtime. El `package.json` no declara `dependencies`. Para desarrollo local solo necesitas Node y opcionalmente PowerShell.

```bash
# verifica que Node cumple la versión mínima
node -v   # >= 16.7

# verifica git (requerido por el binario en proyectos destino)
git --version
```

### Probar el instalador localmente

El instalador es el binario del paquete. Para validarlo contra el repo local sin publicar:

```bash
# corre el binario contra el cwd actual; copiará el runtime a ./.github/
node bin/install.mjs

# con rama alternativa del repo fuente
node bin/install.mjs --branch <rama>

# ayuda
node bin/install.mjs --help
```

> El instalador siempre sobrescribe `.github/` en el destino (overwrite forzado, idempotente, sin confirmación interactiva). Excluye archivos vestigiales con prefijo `old.`.

### Instalación del MCP de Azure DevOps (opcional, opt-in)

Solo se ejecuta bajo demanda del usuario. Configura el servidor MCP remoto HTTP en `.vscode/mcp.json`:

```powershell
# interactivo: pide la organización
.\scripts\install-ado-mcp.ps1

# no interactivo
.\scripts\install-ado-mcp.ps1 -Organization contoso -Force
```

- Idempotente: si `ado-remote-mcp` ya existe en `.vscode/mcp.json`, lo reemplaza y preserva los demás servidores.
- Valida el slug: alfanumérico, guiones, sin protocolo, sin slashes, 2-50 caracteres.
- Usado por la skill `skills/azdevops-test-management/`.

## Development Workflow

### Flujo de edición del contenido runtime

El "código" de este proyecto son los archivos markdown con frontmatter YAML. No hay proceso de build. Para validar cambios:

1. Edita el archivo `.md` (agente, skill, instrucción o prompt).
2. Verifica que el frontmatter YAML sea válido (campos `name`, `description`, `tools`, `applyTo`, `disable-model-invocation`, `user-invocable`, `argument-hint`, `compatibility`, según corresponda al tipo).
3. Si la skill tiene `steps/` y `references/`, asegúrate de que el `SKILL.md` sea un **índice** que liste los pasos en orden; el contenido detallado vive en `steps/`. No dupliques el contenido de los pasos en el `SKILL.md`.
4. Prueba la skill cargándola en Copilot Chat (`@<agent>` o slash command) con un escenario real.

### Scripts disponibles

```bash
npm start    # equivale a: node bin/install.mjs
```

Otros scripts de utilidad:

```bash
# timestamp JSON (utc, local, offset, tz) para worklogs
node scripts/current-time.mjs
```

### Sincronización de skills externas

Las skills externas (`create-agentsmd`, `writing-for-agents`) se gestionan con el CLI `skills`:

```bash
# añade una skill externa al workspace .agents/skills/
npx skills add <owner>/<repo> --skill <skill-name>

# el lockfile skills-lock.json registra source, sourceType, skillPath y computedHash
```

No modificar manualmente `skills-lock.json`; el CLI lo gestiona.

### Publicación del paquete

Antes de publicar verifica que el runtime en GitHub esté actualizado, porque el binario clona desde el repo en cada ejecución:

1. Confirma que los cambios en `agents/`, `instructions/`, `prompts/`, `scripts/`, `skills/` estén commiteados y pusheados a `main` del repo `pablotecat/qa-agent-creation`.
2. Bumpea la versión en `package.json` siguiendo SemVer.
3. El tarball solo incluirá `bin/` y `README.md` (definido por `files`).
4. Publica:

```bash
npm publish
```

> Una publicación de paquete **sin** haber pusheado el runtime a GitHub rompe a los usuarios: `npx qa-agents` descargará una versión vieja del runtime.

## Testing Instructions

Este repositorio no tiene suite de tests automatizados. La validación es manual y documental:

### Validación del instalador

```bash
# 1. en un proyecto vacío, corre el binario y verifica que .github/ se llene
node bin/install.mjs

# 2. verifica que los directorios runtime existan en el destino
ls .github/   # agents/, instructions/, prompts/, scripts/, skills/

# 3. re-ejecuta: debe ser idempotente (overwrite forzado, sin errores)
node bin/install.mjs

# 4. verifica que los archivos con prefijo `old.` NO se copien
ls .github/skills/<cualquier-skill>/   # no debe haber archivos old.*
```

### Validación de skills y agentes

- **Sin ejecución automática**: carga cada skill en Copilot Chat y verifica el flujo paso a paso.
- **Lectura obligatoria antes de extender**: si el `SKILL.md` lista pasos, lee `steps/` antes de generar output. El `SKILL.md` es un índice; el contenido vive en `steps/` y `references/`. (Esta regla se documenta por errores previos al asumir autocontención del `SKILL.md`.)
- **Formato de feedback del agente**: responde en chat exactamente una línea seca por paso (`<paso> OK.`) y una línea final con la ruta del reporte. No llenes el chat con narración.

### Convenciones de naming de archivos

- **Agentes**: `agents/QA.<rol>.agent.md` ( ejemplo: `QA.generator.agent.md`).
- **Instrucciones**: `instructions/QA.<rol>.instructions.md` (contrato operativo) y `instructions/QATesting-general.instructions.md` (general).
- **Skills**: `skills/<skill-name>/SKILL.md` con subcarpetas `steps/` (numeradas `01-`, `02-`, ...) y `references/`.
- **Prompts**: `prompts/<nombre>.md`.

## Code Style

### Markdown + YAML frontmatter

- Frontmatter YAML al inicio de cada archivo runtime, separado por `---`.
- Campos según tipo de archivo:
  - **`.agent.md`**: `name`, `description`, `tools`, `user-invocable`, `argument-hint`.
  - **`SKILL.md`**: `name`, `description`, `disable-model-invocation`, `argument-hint`, `compatibility`.
  - **`.instructions.md`**: `name`, `description`, `applyTo` (glob relativo a los archivos del workspace).
- Idioma del contenido: **español neutro** (tú, dime, prueba). Términos técnicos en inglés (`handoff`, `Test Case`, `smoke`, `regression`, etc.).

### PowerShell

- Compatible con PowerShell 5.1 (no usar `ConvertFrom-Json -AsHashtable`, no disponible en 5.1).
- `param()` con `[CmdletBinding()]` al inicio del script.
- `$ErrorActionPreference = 'Stop'`.
- Validación de inputs con funciones helper (`Test-*`).

### JavaScript (ESM)

- `"type": "module"` en `package.json` → `import`/`export`, no `require`.
- Usar solo módulos nativos de Node (`node:fs`, `node:child_process`, `node:os`, `node:path`).
- No añadir dependencies npm; el binario debe seguir siendo dependency-free.
- En Windows, al ejecutar comandos externos largos (`az` con `--description` extensos), usar `azps.ps1` vía PowerShell, no `az.cmd` (límite de 8191 chars de `cmd.exe`).

## Build and Deployment

No hay build. El "deployment" tiene dos facetas distintas:

### 1. Runtime en GitHub (fuente de descarga del binario)

```bash
# los cambios en agentes/skills/instrucciones/prompts/scripts deben estar en main
git add agents/ instructions/ prompts/ scripts/ skills/
git commit -m "<scope>: <descripción>"
git push origin main
```

> Sin push a `main`, `npx qa-agents` seguirá devolviendo la versión anterior del runtime.

### 2. Paquete npm (`qa-agents` en registry)

```bash
# verificar qué irá en el tarball (solo bin/ y README.md)
npm pack --dry-run

npm publish
```

El `files` en `package.json` limita el tarball a `bin/` y `README.md`. No depende de CI; publicación manual.

## Pull Request Guidelines

- **Title format**: `<scope>: <descripción>` (por ejemplo `skill: añade paso de validación de IDs en qa-generator`).
- **Antes de abrir PR**:
  - Verifica el frontmatter YAML de cada `.md` modificado.
  - Si tocaste `bin/install.mjs`, pruébalo en un proyecto vacío (instalación + re-instalación idempotente).
  - Si tocaste una skill, valida que `SKILL.md` siga siendo un índice coherente de `steps/`.
  - Si tocaste `skills-lock.json`, justifica por qué (debe gestionarlo el CLI `skills`).
- **Target branch**: `main`.
- **Runtime MUST be in GitHub**: el PR debe dejar `main` en un estado donde `npx qa-agents` funcione	end-to-end contra el contenido del repo.

## Additional Notes

### Reglas operativas del propietario (deben respetar los agentes)

- **Idioma**: español neutro (tú, dime, prueba). No voseo argentino/rioplatense. Términos técnicos en inglés.
- **Decisiones binarias**: si una decisión es A vs B, preséntala como tal. No inflate opciones con decoys ni tablas comparativas de 4 columnas.
- **Antes de ejecutar/extensionar una skill**: lee `steps/` y `references/`. El `SKILL.md` no es autocontenido.
- **Wrapper bug del sufijo `ephemeral`**: outputs de tools pueden llevar pegado `ephemeral` al último token. Es ruido del wrapper, **no contenido real**; ignóralo. No renombres `algo.mdephemeral` → `algo.md`.
- **Encoding en Windows**: si corres un script Python del skill-creator que lee archivos con acentos, prepend `-X utf8` (o `$env:PYTHONUTF8=1;`) para forzar UTF-8.

### Documentación de referencia

- `README.md` — guía de usuario (instalación, agentes, skills, rutas de salida).
- `roadmap.md` — features realizado + horizontes de futuro (fuente canónica de qué existe y qué vendrá).
- `presentación/` — diagramas SDLC/QA, estructura de agente y skill, links útiles.
- `new-skill.md` — tarea viva: diseño de la skill `azdevops-test-management` + instalación del MCP de Azure DevOps.
- `instructions/preferences/` — historial de calibraciones de agentes (`agent-preferences`).

### Pipeline QA típico

`QA.documentation` → `QA.planner` → `QA.generator` → `QA.prioritization`. Cada agente produce un handoff JSON que consume el siguiente. La unidad de extensión es el **handoff**, no el agente: solo se añade un agente cuando hay un contract nuevo que emitir y otro que consumir.

No crear agentes para tareas humanas (usabilidad, decisión sobre recursos, mediación DEV/PO, decisión de MVP). No reintroducir orquestación automática sin evidencia.
