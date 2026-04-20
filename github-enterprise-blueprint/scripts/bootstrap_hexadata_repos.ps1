param(
    [string]$Org = "hexadata-cloud",
    [switch]$Private = $false,
    [switch]$DryRun = $false
)

$repos = @(
    "hexadata-core",
    "hexadata-ident",
    "hexadata-watson",
    "hexadata-security",
    "hexadata-authenticator",
    "hexadata-bi",
    "hexadata-lab-diamante",
    "hexadata-osint",
    "hexadata-beyond-cloud",
    "hexadata-backup",
    "hexadata-pay",
    "hexadata-architecture",
    "hexadata-sdk",
    "hexadata-api-contracts",
    "hexadata-infra",
    "hexadata-devops",
    "hexadata-design-system"
)

function Assert-GhCli {
    $gh = Get-Command gh -ErrorAction SilentlyContinue
    if (-not $gh) {
        throw "GitHub CLI (gh) no encontrado. Instala desde https://cli.github.com/"
    }
}

function Run-Command {
    param([string]$Cmd)

    Write-Host "> $Cmd" -ForegroundColor DarkGray
    if (-not $DryRun) {
        Invoke-Expression $Cmd
        if ($LASTEXITCODE -ne 0) {
            throw "Fallo ejecutando comando: $Cmd"
        }
    }
}

Assert-GhCli

Write-Host "Bootstrap organizacion: $Org" -ForegroundColor Cyan
Write-Host "Repos a crear: $($repos.Count)" -ForegroundColor Cyan
Write-Host "Modo: $([string]::Join(', ', @($(if ($Private) {'private'} else {'public'}), $(if ($DryRun) {'dry-run'} else {'apply'}))))" -ForegroundColor Cyan

$visibility = if ($Private) { "--private" } else { "--public" }

foreach ($repo in $repos) {
    $full = "$Org/$repo"
    Write-Host "Procesando $full" -ForegroundColor Yellow

    $existsCmd = "gh repo view $full --json name --jq .name"
    $exists = $null
    if (-not $DryRun) {
        $exists = (& gh repo view $full --json name --jq .name 2>$null)
    }

    if ($exists) {
        Write-Host "  - Ya existe, se omite." -ForegroundColor DarkYellow
        continue
    }

    Run-Command "gh repo create $full $visibility --description 'HEXADATA module: $repo' --confirm"
}

Write-Host ""
Write-Host "Bootstrap completado." -ForegroundColor Green
Write-Host "Siguiente paso sugerido:" -ForegroundColor Green
Write-Host "1) Clonar repos prioritarios: core, security, osint" -ForegroundColor Green
Write-Host "2) Aplicar templates desde github-enterprise-blueprint/templates" -ForegroundColor Green
Write-Host "3) Cargar docs en hexadata-architecture" -ForegroundColor Green
