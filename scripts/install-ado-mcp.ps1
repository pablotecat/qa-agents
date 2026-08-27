<#
.SYNOPSIS
    Configura el servidor MCP remoto de Azure DevOps en .vscode/mcp.json.
.DESCRIPTION
    Pregunta la organizacion de Azure DevOps, valida el formato del slug y escribe
    (o mergea) .vscode/mcp.json con la configuracion del servidor remoto HTTP.
    Idempotente: si el server `ado-remote-mcp` ya existe, lo reemplaza con el nuevo
    valor de organizacion; preserva otros servidores MCP configurados.

    La configuracion del MCP es OPT-IN: el usuario decide si quiere gestionar Test
    Plans/Cases en Azure DevOps (vs Jira, Excel, etc.). Este script solo se ejecuta
    bajo demanda del usuario.

    Usado por la skill `Skills/azure-devops-testplan` (runtime: .github/skills/).
.PARAMETER Organization
    Slug de la organizacion de Azure DevOps (ej. 'contoso' para https://dev.azure.com/contoso).
    Si se omite, el script lo pide interactivamente.
.PARAMETER Force
    Sobrescribe un server `ado-remote-mcp` existente sin pedir confirmacion.
.EXAMPLE
    .\install-ado-mcp.ps1
.EXAMPLE
    .\install-ado-mcp.ps1 -Organization contoso -Force
#>
[CmdletBinding()]
param(
    [Parameter(Mandatory = $false)]
    [string]$Organization,

    [switch]$Force
)

$ErrorActionPreference = 'Stop'

# --- Helpers ---

function Test-OrganizationSlug {
    param([string]$Slug)
    # Slug Azure DevOps: alfanumerico, guiones, sin protocolo, sin slashes, 2-50 chars aprox.
    if ([string]::IsNullOrWhiteSpace($Slug)) { return $false }
    if ($Slug -match '^[A-Za-z0-9][A-Za-z0-9\-]{1,48}[A-Za-z0-9]$') { return $true }
    return $false
}

function Read-Organization {
    while ($true) {
        $org = Read-Host -Prompt 'Azure DevOps organization slug (ej. contoso)'
        if (Test-OrganizationSlug -Slug $org) { return $org }
        Write-Warning "Slug invalido: debe ser alfanumerico con guiones (sin protocolo, sin slashes). Ejemplo: 'contoso'."
    }
}

function ConvertTo-Hashtable {
    # Convierte un PSCustomObject (de ConvertFrom-Json -AsHashtable no disponible en PS 5.1)
    # a hashtable mutable anidada.
    param($Node)
    if ($null -eq $Node) { return $null }
    if ($Node -is [Array]) {
        $arr = @()
        foreach ($item in $Node) { $arr += ,(ConvertTo-Hashtable -Node $item) }
        return ,$arr
    }
    if ($Node -is [System.Management.Automation.PSCustomObject]) {
        $ht = @{}
        foreach ($prop in $Node.PSObject.Properties) {
            $ht[$prop.Name] = (ConvertTo-Hashtable -Node $prop.Value)
        }
        return $ht
    }
    return $Node
}

# --- Main ---

Write-Host 'azdevops-mcp setup — configuracion del servidor MCP remoto de Azure DevOps' -ForegroundColor Cyan

if (-not $Organization) {
    $Organization = Read-Organization
}
elseif (-not (Test-OrganizationSlug -Slug $Organization)) {
    Write-Error "El slug -Organization='$Organization' es invalido. Debe ser alfanumerico con guiones, sin protocolo ni slashes."
}

# Rutas
$repoRoot = (Get-Location).Path
$vscodeDir = Join-Path $repoRoot '.vscode'
$mcpPath = Join-Path $vscodeDir 'mcp.json'

Write-Host "  organizacion: $Organization"
Write-Host "  archivo:      $mcpPath"

# Asegurar .vscode/
if (-not (Test-Path -LiteralPath $vscodeDir -PathType Container)) {
    New-Item -ItemType Directory -Path $vscodeDir | Out-Null
    Write-Host "  + creado $vscodeDir"
}

# Cargar o inicializar mcp.json
$config = $null
if (Test-Path -LiteralPath $mcpPath -PathType Leaf) {
    try {
        $raw = Get-Content -LiteralPath $mcpPath -Raw -Encoding UTF8
        if ([string]::IsNullOrWhiteSpace($raw)) {
            $config = @{}
        }
        else {
            $obj = $raw | ConvertFrom-Json
            $config = ConvertTo-Hashtable -Node $obj
        }
    }
    catch {
        Write-Error "No se pudo parsear $mcpPath como JSON. Corrigelo manualmente o borralo. Detalle: $_"
    }
}
else {
    $config = @{}
}

# Asegurar $config.servers hashtable
if (-not $config.ContainsKey('servers') -or $null -eq $config['servers']) {
    $config['servers'] = @{}
}

# Comprobar existencia del server
$serverName = 'ado-remote-mcp'
if ($config['servers'].ContainsKey($serverName) -and -not $Force) {
    $existing = $config['servers'][$serverName]
    $existingOrg = ''
    if ($existing -is [hashtable] -and $existing.ContainsKey('url')) {
        if ($existing['url'] -match 'mcp\.dev\.azure\.com/([^/""\s]+)') {
            $existingOrg = $matches[1]
        }
    }
    if ($existingOrg -eq $Organization) {
        Write-Host "  = server '$serverName' ya configurado para '$Organization'. No hay cambios." -ForegroundColor Green
        Write-Host "  Arranca el server desde VS Code: vista MCP -> Start server 'ado-remote-mcp'." -ForegroundColor DarkGray
        return
    }
    $reply = Read-Host -Prompt "Ya existe server '$serverName' (org: '$existingOrg'). Reemplazar con '$Organization'? [s/N]"
    if ($reply -notmatch '^[sSyY]') {
        Write-Host '  operacion cancelada por el usuario.' -ForegroundColor Yellow
        return
    }
}

# Escribir/actualizar el server
$serverConfig = @{
    url  = "https://mcp.dev.azure.com/$Organization"
    type = 'http'
}
$config['servers'][$serverName] = $serverConfig

# Asegurar inputs[] existe (vacío por defecto; el remote no requiere inputs)
if (-not $config.ContainsKey('inputs')) {
    $config['inputs'] = @()
}

# Serializar con indentacion 2 espacios (estilo VS Code)
$json = $config | ConvertTo-Json -Depth 20

# ConvertTo-Json en PS 5.1 puede meter CRLF; VS Code normaliza al guardar, pero
# forzamos LF para consistencia multiplataforma.
$json = $json -replace "`r`n", "`n"

Set-Content -LiteralPath $mcpPath -Value $json -NoNewline -Encoding utf8

Write-Host "  + configuracion escrita para '$serverName' -> $mcpPath" -ForegroundColor Green
Write-Host "  proximo paso: VS Code -> vista MCP -> Start server '$serverName'." -ForegroundColor DarkGray
Write-Host "  cuando se te pida, inicia sesion con una cuenta Microsoft con acceso a la organizacion '$Organization'." -ForegroundColor DarkGray
