$version        = '6.0.15'
$id             = 'zabbix-agent'
$title          = 'Zabbix Agent'
$url            = 'https://cdn.zabbix.com/zabbix/binaries/stable/6.0/6.0.15/zabbix_agent-6.0.15-windows-i386-openssl.zip'
$url64          = 'https://cdn.zabbix.com/zabbix/binaries/stable/6.0/6.0.15/zabbix_agent-6.0.15-windows-amd64-openssl.zip'
$checksum       = 'b6f6c3b8d85328ed2311e660085ab3bdae3f8682f72169f5edaeeebd9e5514a9'
$checksumType   = 'sha256'
$checksum64     = '105c0ef0845774bc58942d29af5c094aca36f87304e790d286c500d99f0fd570'
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
  Write-Host 'Error installing Zabbix Agent'
  throw $_.Exception
}
