; Test if in live or development mode
if(SubStr(A_ScriptDir, -12) == "\Other\Source")
	mainDir := A_ScriptDir . "\..\.."
else
	mainDir := A_ScriptDir

; Paths for saving data files.
registryDir := mainDir . "\Data\registry"
clsidDir := mainDir . "\Data\clsid"
appDataDir := mainDir . "\Data\appdata"

; Other paths
dllDir := mainDir . "\App\Dll"
splashFile := mainDir . "\Other\Source\PortableAppsSplash.jpg"
