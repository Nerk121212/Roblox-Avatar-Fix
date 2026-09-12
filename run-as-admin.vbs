Option Explicit

Dim shell, fso, batPath, workDir
Set shell = CreateObject("Shell.Application")
Set fso = CreateObject("Scripting.FileSystemObject")

If WScript.Arguments.Count = 0 Then
    WScript.Quit 2
End If

batPath = WScript.Arguments(0)
workDir = fso.GetParentFolderName(batPath)

shell.ShellExecute "cmd.exe", "/d /c """ & batPath & """", workDir, "runas", 1
