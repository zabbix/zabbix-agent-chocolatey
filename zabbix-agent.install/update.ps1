import-module au
. $PSScriptRoot\..\_scripts\all.ps1

$url = 'https://kakers.uk/scripts/zbx_version_check.php'

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

  $download_page = Invoke-WebRequest -UseBasicParsing -Uri $url
  $versions = $download_page.Content -split '\n'
  $version54 = ($versions | Select-String -Pattern '5.4.')[0]
  $version52 = ($versions | Select-String -Pattern '5.2.')[0]
  $version50 = ($versions | Select-String -Pattern '5.0.')[0]
  $version40 = ($versions | Select-String -Pattern '4.0.')[0]


  @{
    Streams = [ordered] @{
      '5.4' = @{
                Version = $version54
                URL32 = "https://cdn.zabbix.com/zabbix/binaries/stable/5.4/$version54/zabbix_agent-$version54-windows-i386-openssl.msi"
                URL64 = "https://cdn.zabbix.com/zabbix/binaries/stable/5.4/$version54/zabbix_agent-$version54-windows-amd64-openssl.msi"
              }
      '5.2' = @{
                Version = $version52
                URL32 = "https://cdn.zabbix.com/zabbix/binaries/stable/5.2/$version52/zabbix_agent-$version52-windows-i386-openssl.msi"
                URL64 = "https://cdn.zabbix.com/zabbix/binaries/stable/5.2/$version52/zabbix_agent-$version52-windows-amd64-openssl.msi"
              }
      '5.0' = @{
                Version = $version50
                URL32 = "https://cdn.zabbix.com/zabbix/binaries/stable/5.0/$version50/zabbix_agent-$version50-windows-i386-openssl.msi"
                URL64 = "https://cdn.zabbix.com/zabbix/binaries/stable/5.0/$version50/zabbix_agent-$version50-windows-amd64-openssl.msi"
              }
      '4.0' = @{
                Version = $version40
                URL32 = "https://cdn.zabbix.com/zabbix/binaries/stable/4.0/$version40/zabbix_agent-$version40-windows-i386-openssl.msi"
                URL64 = "https://cdn.zabbix.com/zabbix/binaries/stable/4.0/$version40/zabbix_agent-$version40-windows-amd64-openssl.msi"
              }
    }
  }
}

update
