#!powershell

# WANT_JSON
# POWERSHELL_COMMON

. "C:\vagrant\library\downloadFile.ps1"
$url = "https://download.microsoft.com/download/1/5/6/156992E6-F7C7-4E55-833D-249BD2348138/ENU/x64/SQLEXPR_x64_ENU.exe"
$storageDir = "C:\vagrant\library"
$output = "$storageDir\SQLEXPR_x64_ENU.exe"

Function GetModuleInfo()
{
   if (Get-Service "SQL Server (SQLEXPRESS)" -ErrorAction SilentlyContinue)
	{	
  		$moduleInfo = $true;
	}else {
    	$moduleInfo = $false;
	}
   
   Write-Host "service exists: $moduleInfo"
   return $moduleInfo;
}

$download_complete = DownloadSQL $url $output
#Extracting the downloaded file
$extractPath = "$storageDir\SQLEXPR"

If(Test-Path $extractPath)
{
    Write-Host "Already extracted!"
}
else
{
	if ($download_complete)
	{
		Write-Host "Extracting..."
		Start-Process "$output" "/Q /x:`"$extractPath`"" -Wait
	}
}

#Execute installer
$executePath = "$extractPath\SETUP.EXE" 
Start-Process "$executePath" "/IACCEPTSQLSERVERLICENSETERMS /Q /ACTION=install /INSTANCEID=SQLEXPRESS /INSTANCENAME=SQLEXPRESS /UPDATEENABLED=FALSE /FEATURES=SQLEngine /SQLCOLLATION=SQL_Latin1_General_CP1_CI_AS " -Wait  #/SECURITYMODE=SQL /SAPWD"

$moduleIsInstalled = GetModuleInfo;
if($moduleIsInstalled)
{
   $result = New-Object psobject @{
       changed = $true
       sql = "Configurations changed"
   };
}
else
{
   $result = New-Object psobject @{
       changed = $false
	   sql = "Installation succesfull"
   };
}

Exit-Json $result;
