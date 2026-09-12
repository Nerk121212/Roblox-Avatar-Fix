## What Was Created

* **Created Roblox Avatar Fix**

  * A dedicated utility designed to fix Roblox avatars, thumbnails, and CDN images when they fail to load.
  * Added support for `tr.rbxcdn.com` and other Roblox CDN domains.
  * The addon works independently and does not require zapret to be installed or running.

* **Created a unified `service.bat` control panel**

  * Enable Avatar Fix
  * Disable Avatar Fix
  * Check Status
  * Displays the current fix status directly in the menu.
  * The structure and control-panel approach of `service.bat` were taken as a foundation from the service management concept used by **zapret**, then adapted specifically for Roblox Avatar Fix.

* **Added `list-exclude-user.txt` integration**

  * Roblox-specific domains are added to a separate marked block.
  * The block can be enabled or removed without affecting other list entries.

* **Added `hosts` integration**

  * The following `tr.rbxcdn.com` entries are used when the fix is enabled:

    * `54.230.253.22`
    * `54.230.253.81`
    * `54.230.253.48`
    * `54.230.253.59`
  * Disabling the fix removes only the entries created by Roblox Avatar Fix.

* **Added automatic administrator elevation**

  * Operations requiring access to the Windows `hosts` file trigger a UAC elevation request.

* **Added safe Enable / Disable handling**

  * Existing `hosts` entries and unrelated list rules are preserved.
  * DNS server settings are not modified.

* **Created PowerShell components**

  * Automatic Roblox list management.
  * `hosts` management.
  * Avatar Fix status handling.

* **Created the initial project structure**

  * `service.bat`
  * `lists`
  * PowerShell scripts
  * README documentation.

### Initial Release

**Roblox Avatar Fix v1.0.1** — the first public release of a dedicated utility for fixing Roblox avatars, thumbnails, and CDN images when they fail to load. The project is designed to operate independently, with its `service.bat` control panel based on the general service-management approach used by **zapret-discord-youtube**, but adapted specifically for Roblox Avatar Fix.
