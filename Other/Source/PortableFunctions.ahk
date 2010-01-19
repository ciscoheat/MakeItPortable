; ----- COM object functions --------------------------------------------------

RegisterComComponent(file, clsid = "")
{
	global clsidDir
	
	if(clsid)
		RegRead, class, HKEY_CLASSES_ROOT, CLSID\%clsid%
	
	if(not clsid or ErrorLevel)
	{
		; Doesn't exist.
		RunWait, regsvr32 /s "%file%"
	}
	else
	{
		; Exists, write restore file to clsid.
		FileCreateDir, %clsIdDir%
		FileAppend, This file will ensure that the com class is not deleted on application exit, %clsidDir%\%clsid%
	}
}

UnregisterComComponent(file, clsid = "")
{
	global clsidDir
	
	clsFile := clsidDir . "\" . clsid
	
	if(not clsid or not FileExist(clsFile))
	{
		; Restore file didn't exist, unregister com component.
		RunWait, regsvr32 /u /s "%file%"
	}
	else
	{
		; Restore file exists, don't do anything to the component.
		FileDelete, %clsFile%
	}
}

; ----- "Documents and Settings\<username>\Application Data" functions --------

ImportToAppData(dirName)
{
	global appDataDir
	
	appDir := A_AppData . "\" . dirName
	portableDir := appDataDir . "\" . dirName
	
	IfExist, %appDir%
	{
		FileMoveDir, %appDir%, %portableDir%--original, 1
	}
	
	IfExist, %portableDir%
	{
		; Make a backup of the dir in case the application corrupts the data.
		FileCopyDir, %portableDir%, %portableDir%--portable-bak, 1
		FileMoveDir, %portableDir%, %appDir%, 1
	}
}

RestoreOldAppData(dirName)
{	
	global appDataDir
	
	appDir := A_AppData . "\" . dirName
	portableDir := appDataDir . "\" . dirName

	IfExist, %appDir%
	{
		FileMoveDir, %appDir%, %portableDir%, 1
	}
	
	IfExist, %portableDir%--original
	{
		FileMoveDir, %portableDir%--original, %appDir%, 1
	}
}

; ----- Registry functions ----------------------------------------------------

ExportFromRegistry(rootKey, subKey, valueName = "")
{
	global registryDir
	
	IfNotExist, %registryDir%
		FileCreateDir, %registryDir%

	key := makeRegistryKey(rootKey, subKey, valueName)
	file := registryDir . "\" . RegExReplace(key, "\\", "--")

	RunWait, regedit.exe /e "%file%.portable.reg" "%key%", Hide
	RegDelete, %rootKey%, %subKey%, %valueName%
	
	; Restore previous settings if first export succeeded
	IfExist, %file%.portable.reg
	{
		IfExist, %file%.original.reg
		{
			RunWait, regedit.exe /s "%file%.original.reg", Hide
			FileDelete, %file%.original.reg
		}
	}
}

ImportToRegistry(rootKey, subKey, valueName = "")
{
	global registryDir
	
	IfNotExist, %registryDir%
		FileCreateDir, %registryDir%

	key := makeRegistryKey(rootKey, subKey, valueName)
	file := registryDir . "\" . RegExReplace(key, "\\", "--")
	
	; If previous settings exists, save them. No file will be created if key doesn't exist.
	RunWait, regedit.exe /e "%file%.original.reg" "%key%", Hide
	
	; Import registry file or clean it for the portable app
	IfExist, %file%.portable.reg
	{
		; Make a backup of the portable reg file in case the application corrupts the data.
		FileCopy, %file%.portable.reg, %file%.portable.reg.bak, 1
		RunWait, regedit.exe /s "%file%.portable.reg", Hide
	}
	Else IfExist, %file%.original.reg
	{
		RegDelete, %rootKey%, %subKey%, %valueName%
	}
}

makeRegistryKey(rootKey, subKey, valueName)
{
	output := rootKey . "\" . subKey
		
	if(valueName)
		output := output . "\" . valueName

	return output
}

; ----- Splash screen functions -----------------------------------------------

DisplaySplash(splashFile)
{
	SplashImage, %splashFile%, b
	SetTimer, SplashOff, -1500
}

SplashOff:
SplashImage, Off
return
