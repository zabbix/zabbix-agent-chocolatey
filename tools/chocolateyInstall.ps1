$version = '2.4.4'

$packageName = 'zabbix-agent'
$installDir = "C:\Program Files\Zabbix Agent"

$url = "http://www.zabbix.com/downloads/$version/zabbix_agents_$version.win.zip"
$url64 = $url

$is64bit = (Get-WmiObject -Class Win32_OperatingSystem | Select-Object OSArchitecture) -match '64'

$service = Get-WmiObject -Class Win32_Service -Filter "Name='Zabbix Agent'"

try {
  $tempDir = "$env:TEMP\chocolatey\zabbix"
  if (![System.IO.Directory]::Exists($tempDir)) {[System.IO.Directory]::CreateDirectory($tempDir)}
  $tempFile = Join-Path $tempDir "zabbix_agent.zip"
  Get-ChocolateyWebFile "$packageName" "$tempFile" "$url" "$url64"
  Get-ChocolateyUnzip "$tempFile" "$tempDir"

  if ($service) {
    $service.StopService()
  }

  if (!(Test-Path $installDir)) {New-Item $installDir -type directory}
  if ($is64bit) {
    Move-Item $tempDir\bin\win64\* $installDir -force
  } else {
    Move-Item $tempDir\bin\win32\* $installDir -force
  }
  if (!(Test-Path $installDir\zabbix_agentd.conf)) {
    Move-Item $tempDir\conf\zabbix_agentd.win.conf $installDir\zabbix_agentd.conf
  }

  $zabbixAgentd = Join-Path $installDir "zabbix_agentd.exe"
  $zabbixConf   = Join-Path $installDir "zabbix_agentd.conf"
  if (!($service)) { Start-ChocolateyProcessAsAdmin "--config `"$zabbixConf`" --install" "$zabbixAgentd" } #service can be already installed
  Install-ChocolateyPath $installDir 'Machine' # Machine will assert administrative rights

  Write-ChocolateySuccess "$packageName"
} catch {
  Write-ChocolateyFailure "$packageName" "$($_.Exception.Message)"
  throw
}
