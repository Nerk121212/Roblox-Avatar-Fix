param([ValidateSet('ON','OFF','REMOVE')][string]$Action='ON')
$ErrorActionPreference='Stop'
$addon=Split-Path -Parent $PSCommandPath
$lists=Join-Path $addon 'lists'
$exclude=Join-Path $lists 'list-exclude-user.txt'
$general=Join-Path $lists 'list-general-user.txt'
$start='# === ROBLOX AVATAR FIX BEGIN ==='
$end='# === ROBLOX AVATAR FIX END ==='
$gstart='# === ROBLOX AVATAR ALT_FIX BEGIN ==='
$gend='# === ROBLOX AVATAR ALT_FIX END ==='
$domains=@('roblox.com','rbxcdn.com','tr.rbxcdn.com','thumbnails.roblox.com','assetdelivery.roblox.com','avatar.roblox.com','avatars.roblox.com','images.roblox.com','cdn.images.roblox.com','catalog.roblox.com','t0.rbxcdn.com','t1.rbxcdn.com','t2.rbxcdn.com','t3.rbxcdn.com','t4.rbxcdn.com','t5.rbxcdn.com','t6.rbxcdn.com','t7.rbxcdn.com','t8.rbxcdn.com')
function ReadText($p){if(Test-Path -LiteralPath $p){$v=[IO.File]::ReadAllText($p);if($null -eq $v){return ''};return $v};return ''}
function RemoveBlock([string]$text,[string]$a,[string]$b){if($null -eq $text){$text=''};$rx='(?ms)^'+[regex]::Escape($a)+'\s*.*?^'+[regex]::Escape($b)+'\s*\r?\n?';return [regex]::Replace($text,$rx,'')}
function AddBlock([string]$text,[string[]]$block){if($null -eq $text){$text=''};if($text.Length -gt 0 -and -not $text.EndsWith([Environment]::NewLine)){$text += [Environment]::NewLine};$text += ($block -join [Environment]::NewLine)+[Environment]::NewLine;return $text}
function WriteText($p,$text){if($null -eq $text){$text=''};[IO.File]::WriteAllText($p,$text,[Text.Encoding]::UTF8)}
$e=RemoveBlock (ReadText $exclude) $start $end
$g=RemoveBlock (ReadText $general) $gstart $gend
if($Action -eq 'ON'){$g=AddBlock $g (@($gstart)+$domains+@($gend))}
elseif($Action -eq 'OFF'){$e=AddBlock $e (@($start)+$domains+@($end))}
WriteText $exclude $e
WriteText $general $g
if($Action -eq 'ON' -and (ReadText $general) -notmatch [regex]::Escape($gstart)){exit 1}
if($Action -eq 'OFF' -and (ReadText $exclude) -notmatch [regex]::Escape($start)){exit 1}
if($Action -eq 'REMOVE' -and ((ReadText $exclude) -match [regex]::Escape($start) -or (ReadText $general) -match [regex]::Escape($gstart))){exit 1}
exit 0
