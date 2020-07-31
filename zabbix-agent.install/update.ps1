import-module au
. $PSScriptRoot\..\_scripts\all.ps1

$product_version = 5.0
$releases = "https://github.com/zabbix/zabbix/releases"

function global:au_SearchReplace {
  @{
    ".\tools\chocolateyInstall.ps1" = @{
      "(?i)(Url64bit\s*=\s*)('.*')"       = "`$1'$($Latest.URL64)'"
      "(?i)(Checksum64\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum64)'"
      "(?i)(ChecksumType64\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType64)'"      
      "(?i)(Url\s*=\s*)('.*')"            = "`$1'$($Latest.URL32)'"
      "(?i)(Checksum\s*=\s*)('.*')"       = "`$1'$($Latest.Checksum32)'"
      "(?i)(ChecksumType\s*=\s*)('.*')"   = "`$1'$($Latest.ChecksumType32)'"
    }
    
    ".\zabbix-agent.install.nuspec" = @{
      "\<version\>.+" = "<version>$($Latest.Version)</version>"
    }

    ".\legal\VERIFICATION.txt" = @{
      "(?i)(x32\surl:).*"                = "`${1} $($Latest.URL32)"
      "(?i)(x64\surl:).*"                = "`${1} $($Latest.URL64)"
      "(?i)(checksum32:).*"              = "`${1} $($Latest.Checksum32)"
      "(?i)(checksum64:).*"              = "`${1} $($Latest.Checksum64)"
      "(?i)(x32:\sGet-RemoteChecksum).*" = "`${1} $($Latest.URL32)"
      "(?i)(x64:\sGet-RemoteChecksum).*" = "`${1} $($Latest.URL64)"
    }
  }
}

function global:au_GetLatest {
  $download_page = Invoke-WebRequest -UseBasicParsing -Uri $releases
  $regex = "\/zabbix\/zabbix\/archive\/\d{1,3}\.\d{1,3}\.\d{1,3}.zip$"
  $url = $download_page.links | Where-Object href -match $regex | Where-Object href -match $product_version | Select-Object -First 1 -expand href

  $version = ([Regex]::Matches($url, '(\d+\.\d+.\d+)+'))
  $version = $version[0].Value

  @{
    URL64 = "https://www.zabbix.com/downloads/$version/zabbix_agent-$version-windows-amd64-openssl.msi"
    URL32 = "https://www.zabbix.com/downloads/$version/zabbix_agent-$version-windows-i386-openssl.msi"
    Version = $version
  }
}

update
