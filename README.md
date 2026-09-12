# Roblox Avatar Fix

Roblox Avatar Fix is a small utility for fixing Roblox avatars, thumbnails, and CDN images when they fail to load.

## Version

**v1.0.1**

## What's new in v1.0.1

- Added `AutoClose` setting to the `service.bat` menu.
- Added one control panel for Enable, Disable, Status, and AutoClose.
- AutoClose can be switched between `ON` and `OFF`.
- The AutoClose setting is saved in `autoclose.cfg`.
- Cleaned up unnecessary script comments and extra output.
- Improved the list and `hosts` management flow.
- Kept DNS server settings unchanged.
- `Enable` and `Disable` only manage the Roblox Avatar Fix blocks they created.
- Updated the project files and list files for the 1.0.1 release.

## Included

- `service.bat`
- PowerShell scripts for list and `hosts` management
- `run-as-admin.vbs`
- Roblox-specific list files in `lists`

## Roblox CDN hosts

When enabled, the fix adds these entries for `tr.rbxcdn.com`:

- `54.230.253.22`
- `54.230.253.81`
- `54.230.253.48`
- `54.230.253.59`

Disabling the fix removes only the managed block created by Roblox Avatar Fix.

## Usage

Run `service.bat` as administrator.

The menu provides:

1. Enable Avatar Fix
2. Disable Avatar Fix
3. Check Status
4. AutoClose
0. Exit

### Previous release

**v1.0.0** — initial public release.
