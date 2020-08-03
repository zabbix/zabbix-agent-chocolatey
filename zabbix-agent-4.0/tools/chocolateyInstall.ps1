$version        = '4.0.23'
$id             = 'zabbix-agent'
$title          = 'Zabbix Agent'
$url            = 'https://www.zabbix.com/downloads/4.0.23/zabbix_agent-4.0.23-windows-i386-openssl.zip'
$url64          = 'https://www.zabbix.com/downloads/4.0.23/zabbix_agent-4.0.23-windows-amd64-openssl.zip'
$checksum       = 'c00fcb26a48f666d415c89082daa5de0d81d56fd3164f2e9d3c6ff1428df8175'
$checksumType   = 'sha256'
$checksum64     = '0374598d608641fc41d0525cf00692543a7908b6dfb1764a356eef987607e73d'
$checksumType64 = 'sha256'

$configDir      = Join-Path $env:PROGRAMDATA 'zabbix'
$zabbixConf     = Join-Path $configDir 'zabbix_agentd.conf'

$installDir     = Join-Path $env:PROGRAMFILES $title
$zabbixAgentd   = Join-Path $installDir 'zabbix_agentd.exe'

$tempDir        = Join-Path $env:TEMP 'chocolatey\zabbix'
$binDir         = Join-Path $tempDir 'bin'
$binFiles       = @('zabbix_agentd.exe', 'zabbix_get.exe', 'zabbix_sender.exe')
$sampleConfig   = Join-Path $tempDir 'conf\zabbix_agentd.conf'

$is64bit = (Get-WmiObject -Class Win32_OperatingSystem | Select-Object OSArchitecture) -match '64'
$service = Get-WmiObject -Class Win32_Service -Filter "Name=`'$title`'"

try {
  if ($service) {
    $service.StopService()
  }

  if (!(Test-Path $configDir)) {
    New-Item $configDir -type directory
  }

  if (!(Test-Path $installDir)) {
    New-Item $installDir -type directory
  }

  if (!(Test-Path $tempDir)) {
    New-Item $tempDir -type directory
  }

  if ($is64bit) {
    $zipFile = Join-Path $tempDir "zabbix_agent-$version-windows-amd64-openssl.zip"
  } else {
    $zipFile = Join-Path $tempDir "zabbix_agent-$version-windows-i386-openssl.zip"
  }

  Get-ChocolateyWebFile -PackageName "$id" -FileFullPath "$zipFile" -Url "$url" -Url64bit "$url64" -Checksum "$checksum" -ChecksumType "$checksumType" -Checksum64 "$checksum64" -ChecksumType64 "$checksumType64"
  Get-ChocolateyUnzip "$zipFile" "$tempDir"

  foreach ($executable in $binFiles ) {
    $file = Join-Path $binDir $executable
    Move-Item $file $installDir -Force
  }

  if (Test-Path "$installDir\zabbix_agentd.conf") {
    if ($service) {
      $service.Delete()
      Clear-Variable -Name $service
    }

    Move-Item "$installDir\zabbix_agentd.conf" "$configDir\zabbix_agentd.conf" -Force

  } elseif (Test-Path "$configDir\zabbix_agentd.conf") {
    $configFile = "$configDir\zabbix_agentd-$version.conf"
    Move-Item $sampleConfig $configFile -Force

  } else {
    $configFile = "$configDir\zabbix_agentd.conf"
    Move-Item $sampleConfig $configFile

  }

  if (!($service)) {
    Start-ChocolateyProcessAsAdmin "--config `"$zabbixConf`" --install" "$zabbixAgentd"
  }

  Start-Service -Name $title

  Install-ChocolateyPath $installDir 'Machine'

} catch {
  Write-Host "Error installing Zabbix Agent"
  throw $_.Exception
}
