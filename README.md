## Requirements

* Windows 10 / Windows 11
* Права администратора для операций, связанных с `hosts`

## What Was Created

## Version

**v1.0.2**

## What's new in v1.0.2

* Redesigned the `service.bat` control panel with a new CMD interface.
* Added a custom `Roblox Avatar Fix` CMD title and interface color.
* Added a new visual status display for Avatar Fix and AutoClose.
* Added a `Refresh Status` option to the menu.
* Improved the AutoClose toggle interface.
* Changed administrator elevation from `run-as-admin.vbs` to PowerShell `Start-Process -Verb RunAs`.
* Added automatic detection of the addon and list directory location.
* Added automatic creation of the `lists` directory when it is missing.
* Added automatic recreation and repair of `list-exclude-user.txt` when the file is missing.
* Changed the missing-list status from `NO LIST FILE` to `REPAIRING`.
* Improved handling of missing PowerShell scripts and required project files.
* Simplified and reorganized the list and `hosts` management scripts.
* Reduced unnecessary comments and shortened the PowerShell scripts.
* Simplified the release package by removing unused helper and list files.

## Included

* `service.bat`
* `update-list.ps1`
* `update-hosts.ps1`
* `remove-list.ps1`
* `list-exclude-user.txt` in `lists`

## Roblox CDN hosts

When enabled, the fix adds these entries for `tr.rbxcdn.com`:

* `54.230.253.22`
* `54.230.253.81`
* `54.230.253.48`
* `54.230.253.59`

Disabling the fix removes only the managed block created by Roblox Avatar Fix.

## Usage

Run `service.bat` as administrator.

The menu provides:

1. Enable Avatar Fix
2. Disable Avatar Fix
3. Refresh Status
4. Toggle AutoClose
5. Exit

### Previous release

**v1.0.1** — previous release with the AutoClose control panel and persistent AutoClose configuration.

### Initial Release

**Roblox Avatar Fix v1.0.2** — the first public release of a dedicated utility for fixing Roblox avatars, thumbnails, and CDN images when they fail to load. The project is designed to operate independently, with its `service.bat` control panel based on the general service-management approach used by **zapret**, but adapted specifically for Roblox Avatar Fix.


