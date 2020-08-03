import-module au
. $PSScriptRoot\..\_scripts\all.ps1

$release = '4.0'
$url = "https://kakers.uk/scripts/zbx_version_check.php?version=$release"

function global:au_SearchReplace {
  @{
    ".\tools\chocolateyInstall.ps1" = @{
      "(?i)(Url64\s*=\s*)('.*')"          = "`$1'$($Latest.URL64)'"
      "(?i)(Checksum64\s*=\s*)('.*')"     = "`$1'$($Latest.Checksum64)'"
      "(?i)(ChecksumType64\s*=\s*)('.*')" = "`$1'$($Latest.ChecksumType64)'"      
      "(?i)(Url\s*=\s*)('.*')"            = "`$1'$($Latest.URL32)'"
      "(?i)(Checksum\s*=\s*)('.*')"       = "`$1'$($Latest.Checksum32)'"
      "(?i)(ChecksumType\s*=\s*)('.*')"   = "`$1'$($Latest.ChecksumType32)'"
      "(?i)(version\s*=\s*)('.*')"        = "`$1'$($Latest.Version)'"
    }
    
    ".\zabbix-agent.nuspec" = @{
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
  
  $download_page = Invoke-WebRequest -UseBasicParsing -Uri $url
  $version = ($download_page.Content -split '\n')[0]
  
  @{
    URL32 = "https://www.zabbix.com/downloads/$version/zabbix_agent-$version-windows-i386-openssl.zip"
    URL64 = "https://www.zabbix.com/downloads/$version/zabbix_agent-$version-windows-amd64-openssl.zip"
    Version = $version
  }
}

update
