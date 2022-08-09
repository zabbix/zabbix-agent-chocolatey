$ErrorActionPreference = 'Stop';

$packageName        = 'zabbix-agent2'
$version            = '6.2.1'
$url64              = "https://cdn.zabbix.com/zabbix/binaries/stable/6.2/$version/zabbix_agent2-$version-windows-amd64-openssl.msi"
$checksum64         = "cf3babd1718591dd8336d5b4b2282455833b999a407891863d40f8e6df250640"
$installFolder      = "$Env:ProgramFiles\zabbix-agent2"
$silentArgs         = "/qn /norestart /l*v zabbix-log.txt"
#$silentArgs         = "/qn /norestart"
# Parameters
$pp = Get-PackageParameters
if ($pp.LOGTYPE) { $SilentArgs += " LOGTYPE=`"$($pp.LOGTYPE)`"" }
if ($pp.LOGFILE) { $SilentArgs += " LOGFILE=`"$($pp.LOGFILE)`"" }
if ($pp.SERVER) { $SilentArgs += " SERVER=`"$($pp.SERVER)`"" } else { $SilentArgs += " SERVER=`"127.0.0.1`"" }
if ($pp.LISTENPORT) { $SilentArgs += " LISTENPORT=`"$($pp.LISTENPORT)`"" }
if ($pp.SERVERACTIVE) { $SilentArgs += " SERVERACTIVE=`"$($pp.SERVERACTIVE)`"" }
if ($pp.HOSTNAME) { $SilentArgs += " HOSTNAME=`"$($pp.HOSTNAME)`"" }
if ($pp.TIMEOUT) { $SilentArgs += " TIMEOUT=`"$($pp.TIMEOUT)`"" }
if ($pp.TLSCONNECT) { $SilentArgs += " TLSCONNECT=`"$($pp.TLSCONNECT)`"" }
if ($pp.TLSACCEPT) { $SilentArgs += " TLSACCEPT=`"$($pp.TLSACCEPT)`"" }
if ($pp.TLSPSKIDENTITY) { $SilentArgs += " TLSPSKIDENTITY=`"$($pp.TLSPSKIDENTITY)`"" }
if ($pp.TLSPSKFILE) { $SilentArgs += " TLSPSKFILE=`"$($pp.TLSPSKFILE)`"" }
if ($pp.TLSPSKVALUE) { $SilentArgs += " TLSPSKVALUE=`"$($pp.TLSPSKVALUE)`"" }
if ($pp.TLSCAFILE) { $SilentArgs += " TLSCAFILE=`"$($pp.TLSCAFILE)`"" }
if ($pp.TLSCRLFILE) { $SilentArgs += " TLSCRLFILE=`"$($pp.TLSCRLFILE)`"" }
if ($pp.TLSSERVERCERTISSUER) { $SilentArgs += " TLSSERVERCERTISSUER=`"$($pp.TLSSERVERCERTISSUER)`"" }
if ($pp.TLSSERVERCERTSUBJECT) { $SilentArgs += " TLSSERVERCERTSUBJECT=`"$($pp.TLSSERVERCERTSUBJECT)`"" }
if ($pp.TLSCERTFILE) { $SilentArgs += "  TLSCERTFILE=`"$($pp.TLSCERTFILE)`"" }
if ($pp.TLSKEYFILE) { $SilentArgs += " TLSKEYFILE=`"$($pp.TLSKEYFILE)`"" }
if ($pp.LISTENIP) { $SilentArgs += " LISTENIP=`"$($pp.LISTENIP)`"" }
if ($pp.HOSTINTERFACE) { $SilentArgs += " HOSTINTERFACE=`"$($pp.HOSTINTERFACE)`"" }
if ($pp.HOSTMETADATA) { $SilentArgs += " HOSTMETADATA=`"$($pp.HOSTMETADATA)`"" }
if ($pp.HOSTMETADATAITEM) { $SilentArgs += " HOSTMETADATAITEM=`"$($pp.HOSTMETADATAITEM)`"" }
if ($pp.INSTALLFOLDER) { $SilentArgs += " INSTALLFOLDER=`"$($pp.INSTALLFOLDER)`"" } else { $SilentArgs += " INSTALLFOLDER=`"$installFolder`"" }
if ($pp.ENABLEPATH) { $SilentArgs += " ENABLEPATH=`"$($pp.ENABLEPATH)`"" } else { $SilentArgs += " ENABLEPATH=1" }
if ($pp.SKIP) { $SilentArgs += " SKIP=`"$($pp.SKIP)`"" } else { $SilentArgs += " SKIP=fw" }
if ($pp.INCLUDE) { $SilentArgs += " INCLUDE=`"$($pp.INCLUDE)`"" }
if ($pp.ALLOWDENYKEY) { $SilentArgs += " ALLOWDENYKEY=`"$($pp.ALLOWDENYKEY)`"" }

$packageArgs = @{
  packageName   = $packageName
  fileType      = 'msi'
  silentArgs    = $SilentArgs
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
  else {
    Get-CimInstance -ClassName Win32_Service -Filter "Name=`'$serviceName`'" -ErrorAction SilentlyContinue | Remove-CimInstance -ErrorAction SilentlyContinue
    if (Test-Path "HKLM:\SYSTEM\CurrentControlSet\Services\EventLog\Application\Zabbix Agent 2") {
        Remove-Item "HKLM:\SYSTEM\CurrentControlSet\Services\EventLog\Application\Zabbix Agent 2" -Force -ErrorAction SilentlyContinue -Recurse
        Write-Host "Removing registry entries for $serviceName"
    }
    Write-Host "Removing service $serviceName"
  }
}
else {
  if (Test-Path "HKLM:\CurrentControlSet\Services\EventLog\Application\Zabbix Agent 2") {
      Remove-Item "HKLM:\SYSTEM\CurrentControlSet\Services\EventLog\Application\Zabbix Agent 2" -Force -ErrorAction SilentlyContinue -Recurse
      Write-Host "Removing registry entries for $serviceName"
  }
}

Install-ChocolateyPackage @packageArgs
