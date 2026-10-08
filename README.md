## Requirements

* Windows 10 / Windows 11
* Administrator rights for operations related to `hosts`

## What Was Created

## Version

**v1.0.4**

## Requirements

* Windows 10 / Windows 11
* Administrator rights for operations related to `hosts`

## What Was Created

## Version

**v1.0.4**

## What's new in v1.0.4

### Added

* Added a new **SYSTEM fallback** for `hosts` write operations.
* Added automatic fallback when direct `hosts` modification returns **Access Denied**.
* Added a **SYSTEM-level Scheduled Task** method for writing the managed `hosts` content.
* Added direct `FileStream` based write handling for improved `hosts` file access.
* Added final `hosts` content verification after every write operation.
* Added automatic cleanup for temporary PowerShell workers and scheduled tasks.
* Added a dedicated content builder to keep managed Roblox Avatar Fix entries isolated and consistent.
* Improved retry handling for `hosts` read and write operations.

### Changed

* Reworked `update-hosts.ps1` write logic.
* Standard `hosts` modification is now attempted first.
* When the normal write path fails, the script automatically switches to the **SYSTEM fallback**.
* The managed Roblox Avatar Fix block is rebuilt before applying changes.
* The script now verifies that the final `hosts` file exactly matches the requested state.

### Fixed

* Fixed **Access Denied** failures when the current elevated process cannot directly modify the Windows `hosts` file.
* Fixed unreliable replacement behavior caused by depending only on `Copy-Item` for the final `hosts` write.
* Improved reliability when the `hosts` file is temporarily unavailable or locked.

### Preserved

* Roblox CDN `hosts` mappings remain unchanged.
* Existing managed block markers remain unchanged.
* `ON` / `OFF` operation modes remain unchanged.
* Existing `service.bat` workflow remains compatible.
* No external DNS service is required.
* Existing Roblox Avatar Fix functionality remains preserved.

### Technical

* Direct write path uses `[System.IO.File]` / `FileStream`.
* Fallback path creates a temporary scheduled task running under the **SYSTEM** account.
* The fallback task runs with **Highest** privileges.
* Temporary worker files and scheduled tasks are removed automatically after execution.
* The script performs a final verification read before returning success.

### Build Files

* `service.bat`
* `toggle-alt.ps1`
* `update-list.ps1`
* `update-hosts.ps1`
* `remove-list.ps1`
* `mode.cfg`
* `lists/list-exclude-user.txt`
* `lists/list-general-user.txt`

**Build:** 1.0.4  
**Base:** Roblox Avatar Fix 1.0.3  
**Change Type:** Reliability Update / Hosts Access Fallback


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

**v1.0.3** — previous release with the AutoClose control panel and persistent AutoClose configuration.

### Initial Release

**Roblox Avatar Fix v1.0.1** — the first public release of a dedicated utility for fixing Roblox avatars, thumbnails, and CDN images when they fail to load. The project is designed to operate independently, with its `service.bat` control panel based on the general service-management approach used by **zapret**, but adapted specifically for Roblox Avatar Fix.


