# import.ps1
# ローカル開発者が手動で managed Solution を import するためのヘルパースクリプト。
# CI/CD では .github/workflows/deploy-to-{stg,prd}.yml が同じ処理を実行する。
#
# 使い方（ローカル）:
#   pwsh ./scripts/import.ps1 -SolutionName SampleSolution -EnvUrl https://<env>.crm7.dynamics.com -SettingsFile src/Solutions/SampleSolution/settings/deployment-settings.stg.json

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$SolutionName,

    [Parameter(Mandatory = $true)]
    [string]$EnvUrl,

    [Parameter(Mandatory = $true)]
    [string]$SettingsFile
)

$ErrorActionPreference = 'Stop'

$repoRoot = Resolve-Path "$PSScriptRoot/.."
$outDir = Join-Path $repoRoot 'out'
$srcDir = Join-Path $repoRoot "src/Solutions/$SolutionName"

if (-not (Test-Path $srcDir)) {
    throw "Solution source not found: $srcDir"
}

New-Item -ItemType Directory -Path $outDir -Force | Out-Null

Write-Host "[1/3] Packing $SolutionName as managed"
$zipPath = Join-Path $outDir "${SolutionName}_managed.zip"
pac solution pack `
    --folder $srcDir `
    --zipfile $zipPath `
    --packagetype Managed

Write-Host "[2/3] Selecting environment: $EnvUrl"
pac org select --environment $EnvUrl

Write-Host "[3/3] Importing managed Solution (settings: $SettingsFile)"
pac solution import `
    --path $zipPath `
    --settings-file $SettingsFile `
    --publish-changes `
    --force-overwrite

Write-Host "Done."
