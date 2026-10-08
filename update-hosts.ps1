param([string]$Action='ON')
$ErrorActionPreference='Stop'
$Action=$Action.ToUpperInvariant()
if($Action -ne 'ON' -and $Action -ne 'OFF'){throw 'Invalid action. Use ON or OFF.'}
$Path=Join-Path $env:SystemRoot 'System32\drivers\etc\hosts'
$start='# === ROBLOX AVATAR FIX HOSTS BEGIN ==='
$end='# === ROBLOX AVATAR FIX HOSTS END ==='
function Read-Hosts{
    for($i=0;$i -lt 20;$i++){
        try { return [IO.File]::ReadAllText($Path) }
        catch {
            if($i -eq 19){ throw }
            Start-Sleep -Milliseconds 250
        }
    }
}
function Build-Content([string]$Text){
    $pattern='(?ms)^'+[regex]::Escape($start)+'\s*.*?^'+[regex]::Escape($end)+'\s*\r?\n?'
    $Text=[regex]::Replace($Text,$pattern,'')
    if($Action -eq 'ON'){
        $block=@(
            $start,
            '54.230.253.22 tr.rbxcdn.com',
            '54.230.253.81 tr.rbxcdn.com',
            '54.230.253.48 tr.rbxcdn.com',
            '54.230.253.59 tr.rbxcdn.com',
            $end
        ) -join [Environment]::NewLine
        if($Text.Length -gt 0 -and -not $Text.EndsWith([Environment]::NewLine)){ $Text += [Environment]::NewLine }
        $Text += $block + [Environment]::NewLine
    }
    return $Text
}
function Write-HostsDirect([string]$Content){
    $dir=[IO.Path]::GetDirectoryName($Path)
    $tmp=Join-Path $dir ("hosts.roblox_avatar_fix.{0}.tmp" -f ([Guid]::NewGuid().ToString('N')))
    try{
        [IO.File]::WriteAllText($tmp,$Content,[Text.Encoding]::ASCII)
        for($i=0;$i -lt 8;$i++){
            try{
                $bytes=[IO.File]::ReadAllBytes($tmp)
                $fs=[IO.File]::Open($Path,[IO.FileMode]::OpenOrCreate,[IO.FileAccess]::Write,[IO.FileShare]::ReadWrite)
                try{
                    $fs.SetLength(0)
                    $fs.Write($bytes,0,$bytes.Length)
                    $fs.Flush($true)
                }finally{ $fs.Dispose() }
                return
            }catch{
                if($i -eq 7){ throw }
                Start-Sleep -Milliseconds 400
            }
        }
    }finally{
        Remove-Item -LiteralPath $tmp -Force -ErrorAction SilentlyContinue
    }
}
function Write-HostsSystem([string]$Content){
    $worker=Join-Path $env:TEMP ("roblox_avatar_fix_{0}.ps1" -f ([Guid]::NewGuid().ToString('N')))
    $task='RobloxAvatarFix_' + [Guid]::NewGuid().ToString('N')
    $escaped=[Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($Content))
    $script=@'
$ErrorActionPreference='Stop'
$p='__PATH__'
$b=[Convert]::FromBase64String('__CONTENT__')
$fs=[IO.File]::Open($p,[IO.FileMode]::OpenOrCreate,[IO.FileAccess]::Write,[IO.FileShare]::ReadWrite)
try{$fs.SetLength(0);$fs.Write($b,0,$b.Length);$fs.Flush($true)}finally{$fs.Dispose()}
'@
    $script=$script.Replace('__PATH__',$Path).Replace('__CONTENT__',$escaped)
    [IO.File]::WriteAllText($worker,$script,[Text.Encoding]::UTF8)
    try{
        $tr=New-ScheduledTaskTrigger -Once -At ((Get-Date).AddMinutes(1))
        $act=New-ScheduledTaskAction -Execute 'powershell.exe' -Argument ('-NoProfile -ExecutionPolicy Bypass -File "' + $worker + '"')
        $pri=New-ScheduledTaskPrincipal -UserId 'SYSTEM' -LogonType ServiceAccount -RunLevel Highest
        Register-ScheduledTask -TaskName $task -Trigger $tr -Action $act -Principal $pri -Force | Out-Null
        Start-ScheduledTask -TaskName $task
        for($i=0;$i -lt 40;$i++){
            Start-Sleep -Milliseconds 250
            try{
                $info=Get-ScheduledTaskInfo -TaskName $task
                if($info.LastRunTime -gt $info.RegisteredTime -and $info.LastTaskResult -ne 267009){ break }
            }catch{}
        }
        $check=[IO.File]::ReadAllText($Path)
        if($check -ne $Content){ throw 'SYSTEM write verification failed.' }
    }finally{
        Unregister-ScheduledTask -TaskName $task -Confirm:$false -ErrorAction SilentlyContinue
        Remove-Item -LiteralPath $worker -Force -ErrorAction SilentlyContinue
    }
}
$text=Read-Hosts
$content=Build-Content $text
try{
    Write-HostsDirect -Content $content
}catch{
    Write-HostsSystem -Content $content
}
$verify=[IO.File]::ReadAllText($Path)
if($verify -ne $content){ throw 'hosts verification failed.' }
exit 0
