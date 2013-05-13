$package = "zabbix-agent"
$installDir = Join-Path $env:ProgramFiles "Zabbix Agent"

try
{
  # stop helper services if they're running
  $service = Get-WmiObject -Class Win32_Service -Filter "Name='Zabbix Agent'"
  if ($service) {
    $service.StopService()
    $service.Delete()
  }
  
  Remove-Item $installDir
  
  Write-ChocolateySuccess $package
}
catch
{
  Write-ChocolateyFailure $package "$($_.Exception.Message)"
  throw
}
