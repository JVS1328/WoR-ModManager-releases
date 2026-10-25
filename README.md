<p align="center"><img src="logo.png" width="128" alt="WoR Mod Manager logo"></p>

# WoR Mod Manager

A mod manager for **War of Rights**: one-click install and updates for Red's mods (Red's Corner), add any other mod from a `.pak`, a `.zip` or its Nexus link, switch mods on and off, and manage ReShade presets. Made by Red (Discord: jvsr).

## Download

1. Get `WoR-Mod-Manager-vX.Y.Z.zip` from the [latest release](../../releases/latest) (or from Nexus).
2. Unzip it anywhere and run `WoRModManager.exe`. Nothing is installed.
3. The exe isn't code-signed, so the first time Windows may say "Windows protected your PC": click **More info → Run anyway**.

The manager updates itself; you never need to download it again.

## What's in this repo

| File | What it's for |
|---|---|
| `catalog.txt` | The Red's Corner list. One mod per line: its public GitHub releases repo. Line order is card order, `#` hides a line. Players get changes the next time they open or refresh the manager. |
| Releases | Each manager version: `WoRModManager.exe` (what self-update downloads) and the zip for new downloads. |
| `release.ps1`, `changelog.txt` | How a new manager version is published (below). |

## Releasing a new manager version (Red)

1. In `..\WoR-ModManager` (the private source): bump `<Version>` in `src\WoRModManager.App\WoRModManager.App.csproj`, then run `.\publish.ps1`.
2. Here: write the changes in `changelog.txt`, then

   ```powershell
   .\release.ps1 1.0.3 -DryRun
   .\release.ps1 1.0.3
   ```

3. Upload the new zip from `..\WoR-ModManager\publish\` to Nexus too.

Mod releases live in their own repos: [WoR-MAW-releases](https://github.com/JVS1328/WoR-MAW-releases), [WoR-1812-releases](https://github.com/JVS1328/WoR-1812-releases).
