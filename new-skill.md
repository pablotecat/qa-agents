# Tarea: crear skill `azure-devops-test-cases` + instalar el MCP de Azure DevOps para soporte de Test Plans

## Contexto que vienes a resolver

**IMPORTANTE:**Esto se trabajó con otro agente en otra sesión independiente a esta NO ASUMAS QUE LO QUE PONE AQUÍ ES CORRECTO. DUDA DE TODO Y PREGUNTA SI NECESITAS CONFIRMACIÓN.

El objetivo original es subir esos Test Cases a un **Test Plan de Azure DevOps** (no solo crear Work Items sueltos). En la sesión de descubrimiento se verificó lo siguiente:

### Hallazgos técnicos ya verificados (no los redescubras)

1. **Skill `azure-devops-cli` existente** (viene del repositorio de GitHub `awesome-copilot`, no es propia):
   - NO cubre Test Plans / Test Suites. Su árbol `az devops` / `az boards` / `az pipelines` / `az repos` / `az artifacts` no incluye gestión de Test Plans.
   - Sí permite crear Work Items tipo "Test Case" con `az boards work-item create --type "Test Case"` — pero el campo `Description`/`ReproSteps` recibe texto plano, pierde estructura accionable de pasos Given/When/Then y **no asigna el Test Case a ningún Test Suite**.
   - Para Test Plans queda como escape `az devops invoke --area test --resource ...` apuntando a la Test Management REST API — engorroso y propenso a errores de ruta.

2. `az cli`: PArece no tener comando para crear y administrar test planes ni test cases (comprueba esto, por favor)

2. **Existe MCP oficial: `microsoft/azure-devops-mcp`** (repo `microsoft/azure-devops-mcp`, v2.9.0, vivo — commits hace 1 hora):
   - Es el MCP oficial de Microsoft para Azure DevOps.
   - El dominio **`test-plans`** está soportado y aparece en `docs/TOOLSET.md` del propio repo. Por tanto, SÍ permite crear Test Cases nativos del Test Plans y asignarlos a suites.
   - Tiene dos modos de despliegue equivalentes en funcionalidad, Microsoft recomienda el A:
     - **A) Remoto (HTTP)**: cero instalación, solo un URL `https://mcp.dev.azure.com/{org}` en `.vscode/mcp.json`. Auth OAuth con cuenta Microsoft del VS Code. Updates automáticos server-side.
     - **B) Local (stdio)**: `npx -y @azure-devops/mcp {org} -d core work work-items test-plans`. Requiere Node 20+ en destino, cache npx por workspace.

## Decisión ya tomada

- **Modo: Remoto (A).** Razonamiento: el objetivo es distribuir los agentes a otros proyectos. El remoto no impone Node 20+ en el destino, updates son automáticos y no deja caches npx de ~50MB por workspace. El único parámetro a inyectar por proyecto destino es la `{org}` en la URL.

## Puntos que TÚ debes resolver (tienes el contexto que a mí me falta)

1. **Cómo se distribuye actualmente el paquete instalador** y dónde encaja un script instalador del MCP. Explora tu repo y decide el patrón: ¿un `scripts/install-ado-mcp.ps1` que pregunta la org + valida + escribe `.vscode/mcp.json`? ¿O una plantilla `mcp.json.template` con `{org}` que el usuario reemplaza? Mi voto no vale aquí porque no conozco la topología de tu instalador.

2. **Camino para crear Test Cases en el Plan**: ¿usar las tools MCP `test-plans` nativas (crear TC + asignar a suite en una sola operación) o crear WI con `az boards` y luego `az devops invoke` para asociar a suite? Yo votaría nativo MCP test-plans por coherencia con la decisión de instalar el MCP, pero decide según el toolset real que exponga ese dominio (lee `docs/TOOLSET.md` del repo `microsoft/azure-devops-mcp` antes de comprometerte con tool names concretos).

3. **Topología de la skill nueva**. Siguiendo el patrón de tus skills existentes (`steps/` + `references/` + `SKILL.md` con frontmatter), una propuesta inicial:
   ```
   .github/skills/azure-devops-test-cases/
   ├── SKILL.md
   ├── steps/
   │   ├── 01-resolver-test-plan-suite.md    # identificar IDs destino (Plan + Suite)
   │   ├── 02-parsear-test-cases-md.md        # extraer TEST-REQ-xxx, prerrequisitos, pasos, expected
   │   ├── 03-mapear-a-mcp-tools.md           # field mapping markdown → MCP tool args
   │   ├── 04-crear-test-cases.md             # crear TCs en Test Plan
   │   └── 05-asignar-a-suite.md              # add TCs al Test Suite
   └── references/
       ├── toolset-mapping.md                  # mapeo campos markdown → MCP tools
       └── input-anatomy.md                    # anatomía esperada del .md del generator
   ```
   Adáptala a la convención que ya uses en tus skills (intro del SKILL.md con description que dispare model-invocation, etc.).

4. **Agente consumidor**. Debes decidir si esto es una skill model-invoked que el `QA.generator` puede disparar al final del pipeline (handoff "listo para subir a ADO"), o si conviene un agente explícito (p. ej. `QA.uploader` o `QA.ado-sync`). Tú conoces el resto de los agentes, decídelo.

## Reglas operativas que aplica el propietario de este proyecto

- Idioma: español neutro (tú, dime, prueba), no voseo argentino. Términos técnicos en inglés.
- No inflar opciones binarias en tablas comparativas de 4 columnas — si una decisión es A vs B, preséntala como tal.
- Antes de generar output de una skill nueva con steps/references, **lee los archivos referenciados**; el SKILL.md es un índice, no es autocontenido.
- En Windows, al componer `az` con `--description`/`--discussion` largos: `azps.ps1` en PowerShell, no `az.cmd` (cap de 8191 chars de `cmd.exe`).
- Ignora el sufijo `ephemeral` que pueda pegarse al último token de outputs de tools — es un bug conocido del wrapper, no es contenido real.

## Entregables esperados

1. Decisión escrita sobre las 4 áreas de "Puntos que TÚ debes resolver".
2. `.vscode/mcp.json` (en este proyecto, para probar — rellena `{org}` con la del usuario).
3. Skill nueva bajo `.github/skills/azure-devops-test-cases/` con steps y references siguiendo el patrón de tus skills existentes.
4. Script instalador o plantilla (lo que decidiste en punto 1) que permita replicar la config del MCP en otros proyectos.
5. Agente o hook que conecte la salida de `QA.generator` con esta skill (lo que decidiste en punto 4).
6. Work-log de la sesión (si tienes un patrón tipo `qa-worklog` para trazabilidad).

## Próximo paso inmediato

Empieza por `list_dir` sobre la raíz de tu paquete instalador y sobre `.github/skills/` para entender la topología que sigues. NO asumas que mi propuesta de pasos (`01-...05-...`) es la correcta — tú conoces tus convenciones de naming, orden y carpeta de `references/`.