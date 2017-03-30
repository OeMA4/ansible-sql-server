Function DownloadSQL($url, $downloadPath)
{

    $strFileName = "C:\vagrant\library\SQLEXPR_x64_ENU.exe"
	$start_time = Get-Date
	$uri = new-object System.Uri $url
    
    If(Test-Path $strFileName){
        Write-Host "File Already exists!"
    }
    else{
	    $wc = New-Object System.Net.WebClient
    	$wc.DownloadFile($uri, $downloadPath)
    }

    $success =  ($($(CertUtil -hashfile $strFileName SHA256)[1] -replace " ","") -eq "9ef932397a715c39a18404216e9cfa757f8fcc0ab3a226b48c200538d2a7009d")  
    Write-Host "Download sucess == $success"
    return $success;

}