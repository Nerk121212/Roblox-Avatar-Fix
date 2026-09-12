param(
    [string]$Action = 'ON'
)
$ErrorActionPreference = 'Stop'

$Action = $Action.ToUpperInvariant()
if ($Action -ne 'ON' -and $Action -ne 'OFF') {
    throw "Invalid action. Use ON or OFF."
}

$Path = Join-Path $env:SystemRoot 'System32\drivers\etc\hosts'
$start = '# === ROBLOX AVATAR FIX HOSTS BEGIN ==='
$end   = '# === ROBLOX AVATAR FIX HOSTS END ==='

function Read-Hosts {
    for ($i = 0; $i -lt 20; $i++) {
        try {
            return [System.IO.File]::ReadAllText($Path)
        }
        catch {
            if ($i -eq 19) { throw }
            Start-Sleep -Milliseconds 300
        }
    }
}

function Write-Hosts([string]$Content) {
    $dir = [System.IO.Path]::GetDirectoryName($Path)
    $tmp = Join-Path $dir ("hosts.roblox_avatar_fix.{0}.tmp" -f ([Guid]::NewGuid().ToString('N')))
    try {
        [System.IO.File]::WriteAllText($tmp, $Content, [System.Text.Encoding]::ASCII)
        for ($i = 0; $i -lt 20; $i++) {
            try {
                Copy-Item -LiteralPath $tmp -Destination $Path -Force -ErrorAction Stop
                return
            }
            catch {
                if ($i -eq 19) { throw }
                Start-Sleep -Milliseconds 500
            }
        }
    }
    finally {
        Remove-Item -LiteralPath $tmp -Force -ErrorAction SilentlyContinue
    }
}

$text = Read-Hosts
$pattern = '(?ms)^' + [regex]::Escape($start) + '\s*.*?^' + [regex]::Escape($end) + '\s*\r?\n?'
$text = [regex]::Replace($text, $pattern, '')

if ($Action -eq 'ON') {
    $block = @(
        $start
        '54.230.253.22 tr.rbxcdn.com'
        '54.230.253.81 tr.rbxcdn.com'
        '54.230.253.48 tr.rbxcdn.com'
        '54.230.253.59 tr.rbxcdn.com'
        $end
    ) -join [Environment]::NewLine

    if ($text.Length -gt 0 -and -not $text.EndsWith([Environment]::NewLine)) {
        $text += [Environment]::NewLine
    }
    $text += $block + [Environment]::NewLine
}

Write-Hosts -Content $text
exit 0
