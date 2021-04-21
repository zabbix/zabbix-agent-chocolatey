$ErrorActionPreference = 'Stop';

$packageName        = 'zabbix-agent2'
$version            = '5.2.6'
$url64                = "https://cdn.zabbix.com/zabbix/binaries/stable/5.2/$version/zabbix_agent2-$version-windows-amd64-openssl.msi"
$checksum64         = "b1a3573b58cdf424845cd0adbd1a93342e1ed36dbb5d4005bfac43e14a3fffbf"
$installFolder      = "$Env:ProgramFiles\zabbix-agent2"

$packageArgs = @{
  packageName   = $packageName
  fileType      = 'msi'
  silentArgs    = "/qn /norestart /l*v zabbix-log.txt ENABLEPATH=1 SKIP=fw SERVER=127.0.0.1 INSTALLFOLDER=`"$installFolder`""
  validExitCodes= @(0, 3010, 1641)
  url64bit      = $url64
  checksumType64= 'sha256'
  checksum64    = $checksum64
}

# remove previous install keys if exists

$serviceName = 'Zabbix Agent 2'
# if stopped - remove service, something went wrong
# if running - stop, before msi update
If (Get-Service $serviceName -ErrorAction SilentlyContinue) {
  If ((Get-Service $serviceName).Status -eq 'Running') {
        Stop-Service $serviceName -Force -ErrorAction SilentlyContinue
        Write-Host "Stopping service $serviceName"
    }
  Else {
    Get-CimInstance -ClassName Win32_Service -Filter "Name=`'$serviceName`'" -ErrorAction SilentlyContinue | Remove-CimInstance -ErrorAction SilentlyContinue
    if (Test-Path "HKLM:\SYSTEM\CurrentControlSet\Services\EventLog\Application\Zabbix Agent 2") {
      Remove-Item "HKLM:\SYSTEM\CurrentControlSet\Services\EventLog\Application\Zabbix Agent 2" -Force -ErrorAction SilentlyContinue -Recurse
      Write-Host "Removing registry entries for  $serviceName"
    }
    Write-Host "Removing service $serviceName"
  }
else {
  if (Test-Path "HKLM:\CurrentControlSet\Services\EventLog\Application\Zabbix Agent 2") {
    Remove-Item "HKLM:\SYSTEM\CurrentControlSet\Services\EventLog\Application\Zabbix Agent 2" -Force -ErrorAction SilentlyContinue -Recurse
    Write-Host "Removing registry entries for  $serviceName"
  }
}
}

Install-ChocolateyPackage @packageArgs
