$package = "zabbix-agent"
$installDir = "C:\Program Files\Zabbix Agent"

try
{
  # stop helper services if they're running
  $service = Get-WmiObject -Class Win32_Service -Filter "Name='Zabbix Agent'"
  if ($service) {
    $service.StopService()
    $service.Delete()
  }
  
  Remove-Item $installDir -recurse
  
  Write-ChocolateySuccess $package
}
catch
{
  Write-ChocolateyFailure $package "$($_.Exception.Message)"
  throw
}
