#Requires -Version 5.1
<#
.SYNOPSIS
    Configures the Azure DevOps remote MCP server in .vscode/mcp.json.
.DESCRIPTION
    Prompts for the Azure DevOps organization, validates the slug format, and writes
    (or merges) .vscode/mcp.json with the remote HTTP server configuration.

    Idempotent: if the `ado-remote-mcp` server already exists, it is replaced with
    the new organization value; other MCP servers are preserved.

    MCP configuration is OPT-IN: the user decides whether to manage Test Plans/Cases
    in Azure DevOps (vs Jira, Excel, etc.). This script runs only on user demand.

    Used by the `azure-devops-testplan` skill to bootstrap the MCP server it depends on.
.PARAMETER Organization
    Azure DevOps organization slug (e.g. 'contoso' for https://dev.azure.com/contoso).
    If omitted, the script prompts for it interactively.
.PARAMETER Force
    Overwrites an existing `ado-remote-mcp` server without prompting for confirmation.
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
    # Azure DevOps slug: alphanumeric with hyphens, no protocol, no slashes, 2-50 chars.
    if ([string]::IsNullOrWhiteSpace($Slug)) { return $false }
    if ($Slug -match '^[A-Za-z0-9][A-Za-z0-9\-]{1,48}[A-Za-z0-9]$') { return $true }
    return $false
}

function Read-Organization {
    while ($true) {
        $org = Read-Host -Prompt 'Azure DevOps organization slug (e.g. contoso)'
        if (Test-OrganizationSlug -Slug $org) { return $org }
        Write-Warning "Invalid slug: must be alphanumeric with hyphens (no protocol, no slashes). Example: 'contoso'."
    }
}

function ConvertTo-Hashtable {
    # Recursively converts a PSCustomObject (ConvertFrom-Json -AsHashtable is not
    # available in PowerShell 5.1) to a mutable nested hashtable.
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

Write-Host 'azdevops-mcp setup — configuring the Azure DevOps remote MCP server' -ForegroundColor Cyan

if (-not $Organization) {
    $Organization = Read-Organization
}
elseif (-not (Test-OrganizationSlug -Slug $Organization)) {
    Write-Error "The slug -Organization='$Organization' is invalid. It must be alphanumeric with hyphens, no protocol or slashes."
}

# Paths
$repoRoot = (Get-Location).Path
$vscodeDir = Join-Path $repoRoot '.vscode'
$mcpPath = Join-Path $vscodeDir 'mcp.json'

Write-Host "  organization: $Organization"
Write-Host "  file:         $mcpPath"

# Ensure .vscode/ exists
if (-not (Test-Path -LiteralPath $vscodeDir -PathType Container)) {
    New-Item -ItemType Directory -Path $vscodeDir | Out-Null
    Write-Host "  + created $vscodeDir"
}

# Load or initialize mcp.json
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
        Write-Error "Could not parse $mcpPath as JSON. Fix it manually or delete it. Detail: $_"
    }
}
else {
    $config = @{}
}

# Ensure $config.servers is a hashtable
if (-not $config.ContainsKey('servers') -or $null -eq $config['servers']) {
    $config['servers'] = @{}
}

# Check for existing server
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
        Write-Host "  = server '$serverName' already configured for '$Organization'. No changes." -ForegroundColor Green
        Write-Host "  Start the server from VS Code: MCP view -> Start server 'ado-remote-mcp'." -ForegroundColor DarkGray
        return
    }
    $reply = Read-Host -Prompt "Server '$serverName' already exists (org: '$existingOrg'). Replace with '$Organization'? [y/N]"
    if ($reply -notmatch '^[yY]') {
        Write-Host '  operation cancelled by the user.' -ForegroundColor Yellow
        return
    }
}

# Write/update the server
$serverConfig = @{
    url  = "https://mcp.dev.azure.com/$Organization"
    type = 'http'
}
$config['servers'][$serverName] = $serverConfig

# Ensure inputs[] exists (empty by default; the remote server does not need inputs)
if (-not $config.ContainsKey('inputs')) {
    $config['inputs'] = @()
}

# Serialize with 2-space indentation (VS Code style)
$json = $config | ConvertTo-Json -Depth 20

# ConvertTo-Json on PowerShell 5.1 may emit CRLF; VS Code normalizes on save, but
# we force LF for cross-platform consistency.
$json = $json -replace "`r`n", "`n"

Set-Content -LiteralPath $mcpPath -Value $json -NoNewline -Encoding utf8

Write-Host "  + configuration written for '$serverName' -> $mcpPath" -ForegroundColor Green
Write-Host "  next step: VS Code -> MCP view -> Start server '$serverName'." -ForegroundColor DarkGray
Write-Host "  when prompted, sign in with a Microsoft account that has access to the '$Organization' organization." -ForegroundColor DarkGray
