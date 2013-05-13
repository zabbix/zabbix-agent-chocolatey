#NOTE: Please remove any commented lines to tidy up prior to releasing the package, including this one

$packageName = 'zabbix-agent' # arbitrary name for the package, used in messages
$installDir = Join-Path $env:ProgramFiles "Zabbix Agent"

$url = 'http://www.zabbix.com/downloads/2.0.6/zabbix_agents_2.0.6.win.zip' # download url
$url64 = $url # 64bit URL here or just use the same as $url

$is64bit = [System.IntPtr]::Size -eq 8

# main helpers - these have error handling tucked into them already
# download and unpack a zip file

try { #error handling is only necessary if you need to do anything in addition to/instead of the main helpers
  # other helpers - using any of these means you want to uncomment the error handling up top and at bottom.
  # downloader that the main helpers use to download items
  $tempDir = "$env:TEMP\chocolatey\zabbix"
  if (![System.IO.Directory]::Exists($tempDir)) {[System.IO.Directory]::CreateDirectory($tempDir)}
  $tempFile = Join-Path $tempDir "zabbix_agent.zip"
  Get-ChocolateyWebFile "$packageName" "$tempFile" "$url" "$url64"
  # installer, will assert administrative rights - used by Install-ChocolateyPackage
  #Install-ChocolateyInstallPackage "$packageName" "$installerType" "$silentArgs" '_FULLFILEPATH_' -validExitCodes $validExitCodes
  # unzips a file to the specified location - auto overwrites existing content
  Get-ChocolateyUnzip "$tempFile" "$tempDir"
  
  if (!(Test-Path $installDir)) {New-Item $installDir -type directory}
  if ($is64bit) {
    Move-Item $tempDir\bin\win64\* $installDir -force
  } else {
    Move-Item $tempDir\bin\win32\* $installDir -force
  }
  if (!(Test-Path $installDir\zabbix_agentd.conf)) {
    Move-Item $tempDir\conf\zabbix_agentd.win.conf $installDir\zabbix_agentd.conf
  }

  # Runs processes asserting UAC, will assert administrative rights - used by Install-ChocolateyInstallPackage
  $zabbixAgentd = Join-Path $installDir "zabbix_agentd.exe"
  $zabbixConf   = Join-Path $installDir "zabbix_agentd.conf"
  Start-ChocolateyProcessAsAdmin "--config \"$zabbixConf\" --install" "$zabbixAgentd" -validExitCodes @(0,1) #service can be already installed
  # add specific folders to the path - any executables found in the chocolatey package folder will already be on the path. This is used in addition to that or for cases when a native installer doesn't add things to the path.
  Install-ChocolateyPath $installDir 'Machine' # Machine will assert administrative rights
  # add specific files as shortcuts to the desktop
  #$target = Join-Path $MyInvocation.MyCommand.Definition "$($packageName).exe"
  #Install-ChocolateyDesktopLink $target
  
  #------- ADDITIONAL SETUP -------#
  # make sure to uncomment the error handling if you have additional setup to do

  #$processor = Get-WmiObject Win32_Processor
  #$is64bit = $processor.AddressWidth -eq 64

  
  # the following is all part of error handling
  Write-ChocolateySuccess "$packageName"
} catch {
  Write-ChocolateyFailure "$packageName" "$($_.Exception.Message)"
  throw 
}
