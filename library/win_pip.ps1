#!powershell

# WANT_JSON
# POWERSHELL_COMMON

Function VerifyRequirements()
{
   if ((Get-Command "python" -ErrorAction SilentlyContinue) -eq $null)
   {
      Fail-Json (New-Object psobject) "Unable to find python in your PATH";
   }

   if ((Get-Command $pip -ErrorAction SilentlyContinue) -eq $null)
   {
      Fail-Json (New-Object psobject) "Unable to find pip in your PATH";
   }
}

Function GetPipCommand()
{
   $command = "list";
   if($moduleName -ne $FALSE)
   {
      $command = "";
      if($state -eq "present"){
         $command = "install";
      }
      else
      {
         Fail-Json (New-Object psobject) "Did not recognize state $state";
      }
   }
   return $command;
}

Function GetModuleInfo($moduleName)
{
   $moduleInfo = & $pip "show" $moduleName;
   return $moduleInfo;
}

Function GetProcessResultOrFail($file, $arguments)
{
   $psi = New-object System.Diagnostics.ProcessStartInfo
   $psi.CreateNoWindow = $true
   $psi.UseShellExecute = $false
   $psi.RedirectStandardOutput = $true
   $psi.RedirectStandardError = $true
   $psi.FileName = $file
   $psi.Arguments = $arguments

   $process = New-Object System.Diagnostics.Process
   $process.StartInfo = $psi
   [void]$process.Start()
   $output = $process.StandardOutput.ReadToEnd()
   $stderr = $process.StandardError.ReadToEnd()
   $process.WaitForExit()

   if($process.ExitCode -eq 0)
   {
      return $output;
   }
   else
   {
      Fail-Json (New-Object psobject) "Fooo: $stderr";
   }
}


$params = Parse-Args $args $true;

$moduleName = Get-Attr $params "name" $FALSE;
$state = Get-Attr $params "state" "present";

$pip = "pip";

VerifyRequirements;

$pipCommand = GetPipCommand;

$moduleInfo = GetModuleInfo $moduleName;
$moduleIsInstalled = !([string]::IsNullOrEmpty($moduleInfo))

$result = $FALSE;
if($moduleIsInstalled)
{
   $result = New-Object psobject @{
       changed = $false
       pip = "Module is already installed: "+$moduleInfo
   };
}
else
{
   $pipResult = GetProcessResultOrFail $pip @($pipCommand, $moduleName);

   $result = New-Object psobject @{
       changed = $true
       pip = $pipResult
   };
}

Exit-Json $result;
