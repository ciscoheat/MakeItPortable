#Include PortablePaths.ahk

; ----- Your program starts here ------------------------------------
#NoTrayIcon

; Application name, points to the App dir.
appName := "ApplicationName"
appExeFile := mainDir . "\App\" . appName "\" . appName . ".exe"

; Display splash
DisplaySplash(splashFile)

;RegisterComComponent(dllDir . "\COMPONENT.dll", "{guidguid-0123-0123-0123-012301230123}")
;ImportToAppData(appName)
;ImportToRegistry("HKEY_CURRENT_USER", "Software\" . appName)

; Run the application.
;RunWait, %appExeFile%

;ExportFromRegistry("HKEY_CURRENT_USER", "Software\" . appName)
;RestoreOldAppData(appName)
;UnRegisterComComponent(dllDir . "\COMPONENT.dll", "{guidguid-0123-0123-0123-012301230123}")

; End of story.
ExitApp

; ----- Your program ends here --------------------------------------

#Include PortableFunctions.ahk
