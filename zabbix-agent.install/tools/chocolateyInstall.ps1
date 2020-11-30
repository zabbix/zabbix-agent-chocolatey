$ErrorActionPreference = 'Stop';

$title = 'Zabbix Agent'

$installDir = Join-Path $env:PROGRAMFILES $title

$pp = Get-PackageParameters
$INSTALLFOLDER        = if ($pp.INSTALLFOLDER) { $pp.INSTALLFOLDER } else { $installDir }
$LOGTYPE              = if ($pp.LOGTYPE) { $pp.LOGTYPE } else { 'file' }
$LOGFILE              = if ($pp.LOGFILE) { $pp.LOGFILE } else { "$INSTALLFOLDER\zabbix_agentd.log" }
$ENABLEREMOTECOMMANDS = if ($pp.ENABLEREMOTECOMMANDS) { $pp.ENABLEREMOTECOMMANDS } else { '0' }
$SERVER               = if ($pp.SERVER) { $pp.SERVER } else { '127.0.0.1' }
$LISTENPORT           = if ($pp.LISTENPORT) { $pp.LISTENPORT } else { '10050' }
$SERVERACTIVE         = if ($pp.SERVERACTIVE) { $pp.SERVERACTIVE } else { $SERVER }
$HOSTNAME             = if ($pp.HOSTNAME) { $pp.HOSTNAME } else { $env:COMPUTERNAME }
$TIMEOUT              = if ($pp.TIMEOUT) { $pp.TIMEOUT } else { '3' }
$TLSCONNECT           = if ($pp.TLSCONNECT) { $pp.TLSCONNECT } else { 'unencrypted' }
$TLSACCEPT            = if ($pp.TLSACCEPT) { $pp.TLSACCEPT } else { 'unencrypted' }
$TLSPSKIDENTITY       = if ($pp.TLSPSKIDENTITY) { $pp.TLSPSKIDENTITY } else { '' }
$TLSPSKFILE           = if ($pp.TLSPSKFILE) { $pp.TLSPSKFILE } else { '' }
$TLSPSKVALUE          = if ($pp.TLSPSKVALUE) { $pp.TLSPSKVALUE } else { 0 }
$TLSCAFILE            = if ($pp.TLSCAFILE) { $pp.TLSCAFILE } else { '' }
$TLSCRLFILE           = if ($pp.TLSCRLFILE) { $pp.TLSCRLFILE } else { '' }
$TLSSERVERCERTISSUER  = if ($pp.TLSSERVERCERTISSUER) { $pp.TLSSERVERCERTISSUER } else { '' }
$TLSSERVERCERTSUBJECT = if ($pp.TLSSERVERCERTSUBJECT) { $pp.TLSSERVERCERTSUBJECT } else { '' }
$TLSCERTFILE          = if ($pp.TLSCERTFILE) { $pp.TLSCERTFILE } else { '' }
$TLSKEYFILE           = if ($pp.TLSKEYFILE) { $pp.TLSKEYFILE } else { '' }
$ENABLEPATH           = if ($pp.ENABLEPATH) { $pp.ENABLEPATH } else { 0 }
$SKIP                 = if ($pp.SKIP) { $pp.SKIP } else { 0 }

$SilentArgs = "/qn /norestart"
$SilentArgs += " INSTALLFOLDER=`"$INSTALLFOLDER`" LOGTYPE=`"$LOGTYPE`" LOGFILE=`"$LOGFILE`" ENABLEREMOTECOMMANDS=`"$ENABLEREMOTECOMMANDS`" SERVER=`"$SERVER`" LISTENPORT=`"$LISTENPORT`" SERVERACTIVE=`"$SERVERACTIVE`" HOSTNAME=`"$HOSTNAME`" TIMEOUT=`"$TIMEOUT`" TLSCONNECT=`"$TLSCONNECT`" TLSACCEPT=`"$TLSACCEPT`" TLSPSKIDENTITY=`"$TLSPSKIDENTITY`" TLSPSKFILE=`"$TLSPSKFILE`" TLSCAFILE=`"$TLSCAFILE`" TLSCRLFILE=`"$TLSCRLFILE`" TLSSERVERCERTISSUER=`"$TLSSERVERCERTISSUER`" TLSSERVERCERTSUBJECT=`"$TLSSERVERCERTSUBJECT`" TLSCERTFILE=`"$TLSCERTFILE`" TLSKEYFILE=`"$TLSKEYFILE`" ENABLEPATH=`"$ENABLEPATH`" SKIP=`"$SKIP`""

# TLSPSKVALUE does not like being set if it isn't being used.
if ($TLSPSKVALUE -ne 0) { $SilentArgs += " TLSPSKVALUE=`"$TLSPSKVALUE`"" }

$packageArgs = @{
  PackageName    = $env:ChocolateyPackageName
  FileType       = 'MSI'
  Url            = 'https://www.zabbix.com/downloads/5.0.6/zabbix_agent-5.0.6-windows-i386-openssl.msi'
  Url64bit       = 'https://www.zabbix.com/downloads/5.0.6/zabbix_agent-5.0.6-windows-amd64-openssl.msi'
  Checksum       = 'aceebf6ae0f5efccc7a45c42fb5d4c6bcdd683f1a2fcfe7ace4f9407b1bf9f50'
  ChecksumType   = 'sha256'
  Checksum64     = '6baea7609b1d26d5a8dcbeaedf6d6dd1870e18a4f00b7df851c9619758ababe5'
  ChecksumType64 = 'sha256'

  SilentArgs     = $SilentArgs
  ValidExitCodes = @(0, 3010, 1641)
}

Install-ChocolateyPackage @PackageArgs
