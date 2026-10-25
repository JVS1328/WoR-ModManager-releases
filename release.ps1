# Publishes a new WoR Mod Manager version. See README.md.
# First, in ..\WoR-ModManager: bump <Version> in src\WoRModManager.App\WoRModManager.App.csproj and run .\publish.ps1.
# Then here:  .\release.ps1 1.0.3 -DryRun   (check)     .\release.ps1 1.0.3   (publish)
param(
    [Parameter(Mandatory)][string]$Version,
    [switch]$DryRun
)
$ErrorActionPreference = 'Stop'

$Repo = 'JVS1328/WoR-ModManager-releases'
$Pub  = Join-Path $PSScriptRoot '..\WoR-ModManager\publish'
$exe  = Join-Path $Pub 'WoRModManager.exe'
$zip  = Join-Path $Pub "WoR-Mod-Manager-v$Version.zip"
$changelog = Join-Path $PSScriptRoot 'changelog.txt'

if ($Version -notmatch '^\d+\.\d+\.\d+$') { throw "Version must look like 1.0.3 (got '$Version')." }
$Tag = "v$Version"
foreach ($f in $exe, $zip) { if (-not (Test-Path $f)) { throw "Missing $f. Run .\publish.ps1 in WoR-ModManager first." } }
$built = (Get-Item $exe).VersionInfo.FileVersion
if (-not $built.StartsWith("$Version.")) { throw "WoRModManager.exe is version $built, not $Version. Bump <Version> and run publish.ps1 again." }

$problems = @()
$notes = Get-Content $changelog -Raw -ErrorAction SilentlyContinue
if (-not $notes -or $notes -match 'WRITE WHAT CHANGED') { $problems += "Write this version's changes in changelog.txt first." }

Write-Host "WoR Mod Manager $Tag  |  exe $([math]::Round((Get-Item $exe).Length / 1MB, 1)) MB  |  zip $([math]::Round((Get-Item $zip).Length / 1MB, 1)) MB"
foreach ($p in $problems) { Write-Warning $p }
if ($DryRun) { Write-Host 'Dry run: nothing uploaded.'; return }
if ($problems) { throw 'Fix the warnings above first.' }

# Native-command stderr would trip 'Stop' in Windows PowerShell, so git/gh calls check $LASTEXITCODE instead.
$ErrorActionPreference = 'Continue'
gh release view $Tag --repo $Repo *> $null
if ($LASTEXITCODE -eq 0) { throw "$Tag already exists on $Repo. Pick a new version number." }

git -C $PSScriptRoot add changelog.txt
git -C $PSScriptRoot commit -q -m "Release $Tag" --allow-empty
git -C $PSScriptRoot push -q
if ($LASTEXITCODE -ne 0) { throw 'git push failed; nothing was released.' }

gh release create $Tag $exe $zip --repo $Repo --title "WoR Mod Manager $Version" --notes-file $changelog
if ($LASTEXITCODE -ne 0) { throw "Upload failed. Delete the half-made release on GitHub ($Tag) and run this again." }
Write-Host "Published $Tag. Running managers offer it on their next launch; upload the zip to Nexus for new downloads."
