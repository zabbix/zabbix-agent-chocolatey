$ErrorActionPreference = 'Stop';

$SilentArgs = "/qn /norestart"

$pp = Get-PackageParameters
if ($pp.LOGTYPE) { $SilentArgs += " LOGTYPE=`"$($pp.LOGTYPE)`"" }
if ($pp.LOGFILE) { $SilentArgs += " LOGFILE=`"$($pp.LOGFILE)`"" }
if ($pp.SERVER) { $SilentArgs += " SERVER=`"$($pp.SERVER)`"" } else { $SilentArgs += " SERVER=`"127.0.0.1`"" }
if ($pp.LISTENPORT) { $SilentArgs += " LISTENPORT=`"$($pp.LISTENPORT)`"" }
if ($pp.SERVERACTIVE) { $SilentArgs += " SERVERACTIVE=`"$($pp.SERVERACTIVE)`"" }
if ($pp.HOSTNAME) { $SilentArgs += " HOSTNAME=`"$($pp.HOSTNAME)`"" }
if ($pp.TIMEOUT) { $SilentArgs += " TIMEOUT=`"$($pp.TIMEOUT)`"" }
if ($pp.TLSCONNECT) { $SilentArgs += " TLSCONNECT=`"$($pp.TLSCONNECT)`"" }
if ($pp.TLSACCEPT) { $SilentArgs += " TLSACCEPT=`"$($pp.TLSACCEPT)`"" }
if ($pp.TLSPSKIDENTITY) { $SilentArgs += " TLSPSKIDENTITY=`"$($pp.TLSPSKIDENTITY)`"" }
if ($pp.TLSPSKFILE) { $SilentArgs += " TLSPSKFILE=`"$($pp.TLSPSKFILE)`"" }
if ($pp.TLSPSKVALUE) { $SilentArgs += " TLSPSKVALUE=`"$($pp.TLSPSKVALUE)`"" }
if ($pp.TLSCAFILE) { $SilentArgs += " TLSCAFILE=`"$($pp.TLSCAFILE)`"" }
if ($pp.TLSCRLFILE) { $SilentArgs += " TLSCRLFILE=`"$($pp.TLSCRLFILE)`"" }
if ($pp.TLSSERVERCERTISSUER) { $SilentArgs += " TLSSERVERCERTISSUER=`"$($pp.TLSSERVERCERTISSUER)`"" }
if ($pp.TLSSERVERCERTSUBJECT) { $SilentArgs += " TLSSERVERCERTSUBJECT=`"$($pp.TLSSERVERCERTSUBJECT)`"" }
if ($pp.TLSCERTFILE) { $SilentArgs += "  TLSCERTFILE=`"$($pp.TLSCERTFILE)`"" }
if ($pp.TLSKEYFILE) { $SilentArgs += " TLSKEYFILE=`"$($pp.TLSKEYFILE)`"" }
if ($pp.LISTENIP) { $SilentArgs += " LISTENIP=`"$($pp.LISTENIP)`"" }
if ($pp.HOSTINTERFACE) { $SilentArgs += " HOSTINTERFACE=`"$($pp.HOSTINTERFACE)`"" }
if ($pp.HOSTMETADATA) { $SilentArgs += " HOSTMETADATA=`"$($pp.HOSTMETADATA)`"" }
if ($pp.HOSTMETADATAITEM) { $SilentArgs += " HOSTMETADATAITEM=`"$($pp.HOSTMETADATAITEM)`"" }
if ($pp.INSTALLFOLDER) { $SilentArgs += " INSTALLFOLDER=`"$($pp.INSTALLFOLDER)`"" }
if ($pp.ENABLEPATH) { $SilentArgs += " ENABLEPATH=`"$($pp.ENABLEPATH)`"" }
if ($pp.SKIP) { $SilentArgs += " SKIP=`"$($pp.SKIP)`"" }
if ($pp.INCLUDE) { $SilentArgs += " INCLUDE=`"$($pp.INCLUDE)`"" }
if ($pp.ALLOWDENYKEY) { $SilentArgs += " ALLOWDENYKEY=`"$($pp.ALLOWDENYKEY)`"" }

$PackageArgs = @{
  PackageName    = $env:ChocolateyPackageName
  FileType       = 'MSI'
  Url            = 'https://cdn.zabbix.com/zabbix/binaries/stable/6.2/6.2.5/zabbix_agent-6.2.5-windows-i386-openssl.msi'
  Url64bit       = 'https://cdn.zabbix.com/zabbix/binaries/stable/6.2/6.2.5/zabbix_agent-6.2.5-windows-amd64-openssl.msi'
  Checksum       = 'bee9f9272dffa3fce993e24fdfb8b3e36a9b9d110b8e38117c8783e2b4a6892e'
  ChecksumType   = 'sha256'
  Checksum64     = 'f3b2ef57654744e4da6b62352f934811ff82b63d503e98247d5f20b47ad862d6'
  ChecksumType64 = 'sha256'

  SilentArgs     = $SilentArgs
  ValidExitCodes = @(0, 3010, 1641)
}

Install-ChocolateyPackage @PackageArgs
