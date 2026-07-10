$ErrorActionPreference = 'Stop'

$RepositoryRoot = Split-Path -Parent $PSScriptRoot
$AppDirectory = Join-Path $RepositoryRoot 'apps/staff_mobile'
$AndroidDirectory = Join-Path $AppDirectory 'android'
$IosDirectory = Join-Path $AppDirectory 'ios'
$MetadataFile = Join-Path $AppDirectory '.metadata'

if ((Test-Path $AndroidDirectory) -and (Test-Path $IosDirectory) -and (Test-Path $MetadataFile)) {
    Write-Host 'Flutter native scaffolding already exists.'
    exit 0
}

$TemporaryDirectory = Join-Path ([System.IO.Path]::GetTempPath()) ("visitflow_flutter_" + [System.Guid]::NewGuid())
$GeneratedProject = Join-Path $TemporaryDirectory 'visitflow_staff'

try {
    New-Item -ItemType Directory -Force -Path $TemporaryDirectory | Out-Null

    flutter create `
        --empty `
        --platforms=android,ios `
        --org=com.visitflow `
        --project-name=visitflow_staff `
        $GeneratedProject

    Remove-Item -Recurse -Force -ErrorAction SilentlyContinue $AndroidDirectory, $IosDirectory
    Copy-Item -Recurse (Join-Path $GeneratedProject 'android') $AndroidDirectory
    Copy-Item -Recurse (Join-Path $GeneratedProject 'ios') $IosDirectory
    Copy-Item (Join-Path $GeneratedProject '.metadata') $MetadataFile

    Write-Host 'Generated Android and iOS Flutter scaffolding in apps/staff_mobile.'
}
finally {
    Remove-Item -Recurse -Force -ErrorAction SilentlyContinue $TemporaryDirectory
}
