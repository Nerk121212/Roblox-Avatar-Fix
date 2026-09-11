Option Explicit

Dim shell, fso, batPath, workDir, cmdArgs
Set shell = CreateObject("Shell.Application")
Set fso = CreateObject("Scripting.FileSystemObject")

If WScript.Arguments.Count = 0 Then
    WScript.Quit 2
End If

batPath = WScript.Arguments(0)
workDir = fso.GetParentFolderName(batPath)

' Run the batch file elevated through UAC.
shell.ShellExecute "cmd.exe", "/d /c """ & batPath & """", workDir, "runas", 1
