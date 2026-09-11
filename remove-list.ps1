param([Parameter(Mandatory=$true)][string]$Path)
$ErrorActionPreference='Stop'
if(Test-Path -LiteralPath $Path){
  $start='# === ROBLOX AVATAR FIX BEGIN ==='
  $end='# === ROBLOX AVATAR FIX END ==='
  $text=Get-Content -LiteralPath $Path -Raw
  $pattern='(?ms)^'+[regex]::Escape($start)+'\s*.*?^'+[regex]::Escape($end)+'\s*\r?\n?'
  $text=[regex]::Replace($text,$pattern,'')
  [System.IO.File]::WriteAllText($Path, $text, [System.Text.Encoding]::UTF8)
}
