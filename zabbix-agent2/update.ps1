﻿import-module au
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

    ".\zabbix-agent2.nuspec" = @{
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
  $version62 = $versions | Select-String -Pattern '6.2.' | Select-object -First 1
  $version60 = $versions | Select-String -Pattern '6.0.' | Select-object -First 1
  $version50 = $versions | Select-String -Pattern '5.0.' | Select-object -First 1


  @{
    Streams = [ordered] @{
      '6.2' = @{
                Version = $version62
                URL32 = "https://cdn.zabbix.com/zabbix/binaries/stable/6.2/$version62/zabbix_agent2-$version62-windows-i386-openssl.msi"
                URL64 = "https://cdn.zabbix.com/zabbix/binaries/stable/6.2/$version62/zabbix_agent2-$version62-windows-amd64-openssl.msi"
              }
      '6.0' = @{
                Version = $version60
                URL32 = "https://cdn.zabbix.com/zabbix/binaries/stable/6.0/$version60/zabbix_agent2-$version60-windows-i386-openssl.msi"
                URL64 = "https://cdn.zabbix.com/zabbix/binaries/stable/6.0/$version60/zabbix_agent2-$version60-windows-amd64-openssl.msi"
              }              
      '5.0' = @{
                Version = $version50
                URL32 = "https://cdn.zabbix.com/zabbix/binaries/stable/5.0/$version50/zabbix_agent2-$version50-windows-i386-openssl.msi"
                URL64 = "https://cdn.zabbix.com/zabbix/binaries/stable/5.0/$version50/zabbix_agent2-$version50-windows-amd64-openssl.msi"
              }
    }
  }
}

update
