# qa-agents

Paquete npm que instala los **agentes QA de GitHub Copilot** en cualquier proyecto. El runtime no va dentro del paquete: el binario lo **descarga desde GitHub** (`pablotecat/qa-agents`) en cada ejecución. Los agentes, skills, instrucciones y prompts quedan en `.github/`, listos para ser invocados desde Copilot.

```bash
npx qa-agents
```

## Instalación

### Modo 1 — Runner completo (recomendado para el pipeline QA)

Instala todo el runtime en `.github/` (overwrite forzado, idempotente, sin confirmación interactiva):

```bash
npx qa-agents            # main por defecto
npx qa-agents --branch develop
```

Copia `agents/`, `instructions/`, `prompts/`, `skills/` → `.github/`.

### Modo 2 — Solo skills (estándar del ecosistema `skills`)

Instala únicamente las carpetas con `SKILL.md` (compatible con 70+ agentes). No instala `.agent.md`, `.instructions.md` ni `prompts/`:

```bash
npx skills add pablotecat/qa-agents
```

## Requisitos

- **Node.js ≥ 16.7** (usa `fs.cpSync` nativo, sin dependencias npm externas).
- **Git** en el PATH (shallow clone del repo).
- Repo `pablotecat/qa-agents **público**.

## Contenido instalado

| Carpeta | Archivos | Descripción |
|---------|----------|-------------|
| `agents/` | 3 | `QA.documentation`, `QA.planner`, `QA.generator` (los `old.*` se excluyen) |
| `instructions/` | 4 | `QA.*.instructions.md` por agente + `QATesting-general` |
| `prompts/` | 1 | `test-documentation-init.md` |
| `skills/` | 5 dirs | `qa-handoff-creation`, `qa-documentation`, `qa-generator`, `qa-planner`, `qa-test-prioritization-report` (cada una con `SKILL.md` + `steps/`/`references/`/`assets/`) |

Los agentes son **invocables directamente**. Las skills de workflow (`qa-documentation`, `qa-generator`, `qa-planner`) también son **invocables de forma autónoma** vía slash command, sin agente.

## Invocación

Cada skill de workflow produce su reporte markdown de forma autónoma. El handoff JSON es **opcional** y lo gestiona el invocador (agente o usuario) vía `qa-handoff-creation`, una vez cerrado el workflow.

- **Vía agente** (pipeline QA): el agente ejecuta su skill de workflow y, opcionalmente, `qa-handoff-creation` para emitir el recibo de validación. Pipeline secuencial manual: `QA.documentation` → `QA.planner` → `QA.generator`. Artefactos en `./tests/Documentation/sessions/`.
- **Vía skill standalone** (sin agente): slash command directo. Devuelve el reporte markdown sin handoff.

### Ruta de salida en modo standalone

1. `to <path>` (o `save [to] <path>`, `en <path>`) → escribe ahí.
2. `preview` o `no-save` → chat-only, nada en disco.
3. Default → `./qa-tmp/<skill-name>/<timestamp>/` (relativo al cwd).

> El modo standalone **no** inicializa la estructura de sesión del agente. Añade `qa-tmp/` al `.gitignore`. Si generas un reporte standalone y luego quieres que un agente lo consuma, pásale el path explícito (no lo encontrará en su carpeta de sesión esperada).

## Artefactos de sesión

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

## Desarrollo y publicación

```bash
# Probar localmente:
node bin/install.mjs
node bin/install.mjs --branch develop

# Publicar:
npm login
npm publish                  # unscoped, público por defecto
npm publish --dry-run        # verificar tarball
```

Para iterar sobre el runtime sin publicar, copia las carpetas del repo a `.github/` de un proyecto de prueba.
