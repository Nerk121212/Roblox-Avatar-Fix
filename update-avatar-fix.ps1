param(
    [Parameter(Mandatory=$true, Position=0)]
    [ValidateSet('ON','OFF')]
    [string]$Action
)

$ErrorActionPreference = 'Stop'

$identity = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal = New-Object Security.Principal.WindowsPrincipal($identity)
if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    $scriptPath = $MyInvocation.MyCommand.Path
    $args = '-NoProfile -ExecutionPolicy Bypass -File "' + $scriptPath + '" ' + $Action
    $proc = Start-Process powershell.exe -ArgumentList $args -Verb RunAs -Wait -PassThru
    exit $proc.ExitCode
}

$Root  = Split-Path -Parent $MyInvocation.MyCommand.Path
$Lists = Join-Path $Root 'lists'
$List  = Join-Path $Lists 'list-exclude-user.txt'
$Hosts = Join-Path $env:SystemRoot 'System32\drivers\etc\hosts'

$ListStart = '# === ROBLOX AVATAR FIX BEGIN ==='
$ListEnd   = '# === ROBLOX AVATAR FIX END ==='
$HostStart = '# === ROBLOX AVATAR FIX HOSTS BEGIN ==='
$HostEnd   = '# === ROBLOX AVATAR FIX HOSTS END ==='

$Domains = @(
    'avatar.roblox.com'
    'avatars.roblox.com'
    'thumbnails.roblox.com'
    'assetdelivery.roblox.com'
    'images.roblox.com'
    'cdn.images.roblox.com'
    'catalog.roblox.com'
    'rbxcdn.com'
    '*.rbxcdn.com'
    'tr.rbxcdn.com'
    't0.rbxcdn.com'
    't1.rbxcdn.com'
    't2.rbxcdn.com'
    't3.rbxcdn.com'
    't4.rbxcdn.com'
    't5.rbxcdn.com'
    't6.rbxcdn.com'
    't7.rbxcdn.com'
    't8.rbxcdn.com'
)

$HostEntries = @(
    '54.230.253.22 tr.rbxcdn.com'
    '54.230.253.81 tr.rbxcdn.com'
    '54.230.253.48 tr.rbxcdn.com'
    '54.230.253.59 tr.rbxcdn.com'
)

function Remove-Block([string]$Text, [string]$Start, [string]$End) {
    if ([string]::IsNullOrEmpty($Text)) { return '' }
    $pattern = '(?ms)^[\t ]*' +
               [regex]::Escape($Start) +
               '[\t ]*\r?\n.*?^[\t ]*' +
               [regex]::Escape($End) +
               '[\t ]*\r?\n?'
    return [regex]::Replace($Text, $pattern, '')
}

function Ensure-NewLine([string]$Text) {
    if ([string]::IsNullOrEmpty($Text)) { return '' }
    if (-not $Text.EndsWith([Environment]::NewLine)) {
        return $Text + [Environment]::NewLine
    }
    return $Text
}

if (-not (Test-Path -LiteralPath $Lists)) {
    New-Item -ItemType Directory -Path $Lists -Force | Out-Null
}
if (-not (Test-Path -LiteralPath $List)) {
    [System.IO.File]::WriteAllText($List, '', (New-Object System.Text.UTF8Encoding($false)))
}

$listText = [System.IO.File]::ReadAllText($List)
$listText = Remove-Block $listText $ListStart $ListEnd

if ($Action -eq 'ON') {
    $block = @($ListStart) + $Domains + @($ListEnd)
    $listText = Ensure-NewLine $listText
    $listText += (($block -join [Environment]::NewLine) + [Environment]::NewLine)
}

[System.IO.File]::WriteAllText($List, $listText, (New-Object System.Text.UTF8Encoding($false)))

$hostText = [System.IO.File]::ReadAllText($Hosts)
$hostText = Remove-Block $hostText $HostStart $HostEnd

if ($Action -eq 'ON') {
    $hostBlock = @($HostStart) + $HostEntries + @($HostEnd)
    $hostText = Ensure-NewLine $hostText
    $hostText += (($hostBlock -join [Environment]::NewLine) + [Environment]::NewLine)
}

$backup = $Hosts + '.roblox-avatar-backup'
try {
    Copy-Item -LiteralPath $Hosts -Destination $backup -Force -ErrorAction Stop

    $bytes = [System.Text.Encoding]::ASCII.GetBytes($hostText)
    $fs = New-Object System.IO.FileStream(
        $Hosts,
        [System.IO.FileMode]::Create,
        [System.IO.FileAccess]::Write,
        [System.IO.FileShare]::ReadWrite
    )
    try {
        $fs.Write($bytes, 0, $bytes.Length)
        $fs.Flush($true)
    }
    finally {
        $fs.Dispose()
    }

    Write-Host "[OK] $Action completed."
    exit 0
}
catch {
    Write-Host "[ERROR] Could not update hosts: $($_.Exception.Message)"
    if (Test-Path -LiteralPath $backup) {
        try { Copy-Item -LiteralPath $backup -Destination $Hosts -Force -ErrorAction SilentlyContinue } catch {}
    }
    exit 1
}
