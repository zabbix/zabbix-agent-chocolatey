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
  Url            = 'https://www.zabbix.com/downloads/4.0.22/zabbix_agent-4.0.22-windows-i386-openssl.msi'
  Url64bit       = 'https://www.zabbix.com/downloads/4.0.22/zabbix_agent-4.0.22-windows-amd64-openssl.msi'
  Checksum       = '0baf34c060f9e6ad39c7f30bfcd96e60c71ccd3457bb1921a7591e4e8c9eedca'
  ChecksumType   = 'sha256'
  Checksum64     = '44fe3e5e617463729f644884a69c4962cde4e351591f8acb3c55a104b720dc8d'
  ChecksumType64 = 'sha256'

  SilentArgs     = $SilentArgs
  ValidExitCodes = @(0, 3010, 1641)
}

Install-ChocolateyPackage @PackageArgs
