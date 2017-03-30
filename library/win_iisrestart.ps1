#!powershell

# WANT_JSON
# POWERSHELL_COMMON

$startcmd = "net start w3svc"
$stopcmd = 'net stop w3svc'

iex $stopcmd
iex $startcmd

$result = New-Object psobject @{
    changed = $false
	iis_restart = "Successfully restarted"
};

Exit-Json $result;