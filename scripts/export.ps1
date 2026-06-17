# export.ps1
# ローカル開発者が手動で Solution を export → unpack するためのヘルパースクリプト。
# CI/CD では .github/workflows/export-from-dev.yml が同じ処理を実行する。
#
# 使い方（ローカル）:
#   pwsh ./scripts/export.ps1 -SolutionName SampleSolution -EnvUrl https://<dev>.crm7.dynamics.com
#
# 前提: Power Platform CLI (pac) インストール済み・pac auth で DEV 環境に認証済み

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$SolutionName,

    [Parameter(Mandatory = $true)]
    [string]$EnvUrl
)

$ErrorActionPreference = 'Stop'

$repoRoot = Resolve-Path "$PSScriptRoot/.."
$outDir = Join-Path $repoRoot 'out'
$srcDir = Join-Path $repoRoot "src/Solutions/$SolutionName"

New-Item -ItemType Directory -Path $outDir -Force | Out-Null

Write-Host "[1/3] Selecting environment: $EnvUrl"
pac org select --environment $EnvUrl

Write-Host "[2/3] Exporting Solution: $SolutionName (unmanaged)"
$zipPath = Join-Path $outDir "$SolutionName.zip"
pac solution export `
    --name $SolutionName `
    --managed false `
    --path $zipPath `
    --overwrite

Write-Host "[3/3] Unpacking into $srcDir"
pac solution unpack `
    --zipfile $zipPath `
    --folder $srcDir `
    --packagetype Unmanaged `
    --allowDelete `
    --allowWrite

Write-Host "Done. Review changes with: git status"
