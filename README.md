## Requirements

* Windows 10 / Windows 11
* Administrator rights for operations related to `hosts`

## What Was Created

## Version

**v1.0.3**

## What's new in v1.0.3

### Added

* Added **ALT_FIX** mode system.
* Added **SAFE / RAGE** mode switching.
* Added persistent mode configuration through `mode.cfg`.
* Added `toggle-alt.ps1` for ALT_FIX list management.
* Added `lists/list-general-user.txt` for the ALT_FIX domain set.
* Added a new **Toggle ALT_FIX mode** option to `service.bat`.
* Added mode-aware status detection in the control panel.
* Added persistent mode handling between launches.

### Changed

* Reworked `service.bat` to support multiple Roblox Avatar Fix modes.
* Updated Enable/Disable logic to operate according to the selected mode.
* Updated list management to use separate blocks for standard and ALT_FIX operation.
* Updated README documentation to reflect the new 1.0.3 functionality.

### Preserved

* Roblox CDN `hosts` management remains unchanged.
* AutoClose functionality remains available and persistent.
* Administrator elevation continues to use PowerShell `Start-Process -Verb RunAs`.
* Existing Roblox CDN domains and managed `hosts` block remain supported.

### Build Files

* `service.bat`
* `toggle-alt.ps1`
* `update-list.ps1`
* `update-hosts.ps1`
* `remove-list.ps1`
* `mode.cfg`
* `lists/list-exclude-user.txt`
* `lists/list-general-user.txt`

**Build:** 1.0.3
**Base:** Roblox Avatar Fix 1.0.2
**Change Type:** Feature Update / Mode System


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

Run `service.bat`.

The menu provides:

1. Enable Avatar Fix
2. Disable Avatar Fix
3. Refresh Status
4. Toggle AutoClose
5. Exit

### Previous release

**v1.0.2** — previous release with the AutoClose control panel and persistent AutoClose configuration.

### Initial Release

**Roblox Avatar Fix v1.0.3** — the first public release of a dedicated utility for fixing Roblox avatars, thumbnails, and CDN images when they fail to load. The project is designed to operate independently, with its `service.bat` control panel based on the general service-management approach used by **zapret**, but adapted specifically for Roblox Avatar Fix.


