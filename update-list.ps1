param([Parameter(Mandatory=$true)][string]$Path)
$ErrorActionPreference='Stop'
$start='# === ROBLOX AVATAR FIX BEGIN ==='
$end='# === ROBLOX AVATAR FIX END ==='
$block=@(
$start
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
$end
) -join [Environment]::NewLine
if(Test-Path -LiteralPath $Path){$text=Get-Content -LiteralPath $Path -Raw}else{$text=''}
$pattern='(?ms)^'+[regex]::Escape($start)+'\s*.*?^'+[regex]::Escape($end)+'\s*\r?\n?'
$text=[regex]::Replace($text,$pattern,'')
if($text.Length -gt 0 -and -not $text.EndsWith([Environment]::NewLine)){ $text += [Environment]::NewLine }
$text += $block + [Environment]::NewLine
[System.IO.File]::WriteAllText($Path, $text, [System.Text.Encoding]::UTF8)
