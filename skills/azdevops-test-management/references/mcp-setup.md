# Setup del MCP de Azure DevOps

Configuración del servidor remoto `microsoft/azure-devops-mcp` necesario para esta skill. Modalidad **remota (HTTP)** — cero instalación local, updates automáticos server-side, auth OAuth con la cuenta Microsoft firmada en VS Code.

## Archivo `.vscode/mcp.json`

La skill espera un servidor con `type: http` apuntando a `https://mcp.dev.azure.com/{organization}`.

```jsonc
{
  "servers": {
    "ado-remote-mcp": {
      "url": "https://mcp.dev.azure.com/{organization}",
      "type": "http"
    }
  },
  "inputs": []
}
```

Reemplaza `{organization}` por el nombre de la organización Azure DevOps (slug, sin `https://`, sin `dev.azure.com/`). Ejemplo: para `https://dev.azure.com/contoso` → `contoso`.

> La skill **NO crea este archivo por defecto** en el repo — la configuración del MCP es opt-in. El usuario decide si quiere gestión en Azure DevOps (vs Jira, Excel, etc.). Ver `SKILL.md` del repo raíz, decisión 1.

## Vía 1: script de configuración (recomendada)

Corre desde la raíz del proyecto:

```powershell
./.github/scripts/install-ado-mcp.ps1
```

El script pregunta la organización valida el formato (alfanumérico y guiones), y escribe/mergea `.vscode/mcp.json` preservando otros servidores MCP que ya estén configurados. Idempotente.

## Vía 2: configuración manual

Si prefieres no correr el script:

1. Crea `.vscode/mcp.json` en la raíz del proyecto (o edítalo si existe).
2. Pega el bloque de arriba reemplazando `{organization}`.
3. Guarda y desde VS Code: vista MCP → Start server `ado-remote-mcp`.
4. Cuando VS Code lo pida, inicia sesión con una cuenta Microsoft que tenga acceso a la organización Azure DevOps indicada.

## Verificación de conectividad

Tras configurar, verifica que el servidor responde antes de usar la skill:

- Abre Copilot Chat en modo agente.
- Pregunta algo simple: `"List ADO projects"`.
- Si la tool `mcp_ado_core_list_projects` responde con tu lista de proyectos, la skill está usable.
- Si recibe errores de auth, vuelve a iniciar sesión en VS Code con la cuenta Microsoft correcta.

## Troubleshooting

- **HTTP 401/403:** la cuenta Microsoft firmada en VS Code no tiene acceso a la organización. Switch account en VS Code.
- **HTTP 404 al invocar tools:** revisa que `{organization}` sea el slug correcto (sin protocolo, sin slashes).
- **Tools no aparecen:** desde VS Code → Command Palette → `MCP: List Servers` y verifica que `ado-remote-mcp` esté `running`. Si no, arráncalo manualmente.
- **Quieres domains filtrados (solo test-plans, no todo):** el modo remoto expone todo el toolset; los domains (`-d core work work-items test-plans`) son una opción del **local** (stdio), no del remoto. Si necesitas acotar tools, migra a local (ver Alternativa local abajo).

## Alternativa local (stdio) — solo si tu escenario lo requiere

El modo remoto cubre esta skill. Solo migra a local si necesitas un setup `stdio` (por ejemplo,air-gapped, o querer limitar tools cargadas con domains). En ese caso la config es:

```jsonc
{
  "inputs": [
    { "id": "ado_org", "type": "promptString", "description": "Azure DevOps organization name (ej. 'contoso')" }
  ],
  "servers": {
    "ado-local": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@azure-devops/mcp", "${input:ado_org}", "-d", "core", "work-items", "test-plans"]
    }
  }
}
```

Requiere Node 20+ en destino. Caches npx (~50MB) por workspace. Para los fines de esta skill, **el remoto es la opción recomendada** y la única documentada con detalle.
