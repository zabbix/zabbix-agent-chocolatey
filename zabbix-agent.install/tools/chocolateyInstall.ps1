$ErrorActionPreference = 'Stop';

$packageName  = 'zabbix-agent.install'
$title        = 'Zabbix Agent'
$version      = '4.4.4'
$url32        = "https://www.zabbix.com/downloads/$version/zabbix_agent-$version-windows-i386-openssl.msi"
$url64        = "https://www.zabbix.com/downloads/$version/zabbix_agent-$version-windows-amd64-openssl.msi"
$checksum32   = 'e7029ef98922307a65afafe7205b107b'
$checksum64   = '809f0402c37d630ae0f1efaae72b46ef'

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

# TLSPSKVALUE does not like being set if it isn't being used.
if ($TLSPSKVALUE -ne 0) {
  $silentArgs = "/qn /norestart INSTALLFOLDER=`"$INSTALLFOLDER`" LOGTYPE=`"$LOGTYPE`" LOGFILE=`"$LOGFILE`" ENABLEREMOTECOMMANDS=`"$ENABLEREMOTECOMMANDS`" SERVER=`"$SERVER`" LISTENPORT=`"$LISTENPORT`" SERVERACTIVE=`"$SERVERACTIVE`" HOSTNAME=`"$HOSTNAME`" TIMEOUT=`"$TIMEOUT`" TLSCONNECT=`"$TLSCONNECT`" TLSACCEPT=`"$TLSACCEPT`" TLSPSKIDENTITY=`"$TLSPSKIDENTITY`" TLSPSKFILE=`"$TLSPSKFILE`" TLSPSKVALUE=`"$TLSPSKVALUE`" TLSCAFILE=`"$TLSCAFILE`" TLSCRLFILE=`"$TLSCRLFILE`" TLSSERVERCERTISSUER=`"$TLSSERVERCERTISSUER`" TLSSERVERCERTSUBJECT=`"$TLSSERVERCERTSUBJECT`" TLSCERTFILE=`"$TLSCERTFILE`" TLSKEYFILE=`"$TLSKEYFILE`" ENABLEPATH=`"$ENABLEPATH`" SKIP=`"$SKIP`""
} else {
  $silentArgs = "/qn /norestart INSTALLFOLDER=`"$INSTALLFOLDER`" LOGTYPE=`"$LOGTYPE`" LOGFILE=`"$LOGFILE`" ENABLEREMOTECOMMANDS=`"$ENABLEREMOTECOMMANDS`" SERVER=`"$SERVER`" LISTENPORT=`"$LISTENPORT`" SERVERACTIVE=`"$SERVERACTIVE`" HOSTNAME=`"$HOSTNAME`" TIMEOUT=`"$TIMEOUT`" TLSCONNECT=`"$TLSCONNECT`" TLSACCEPT=`"$TLSACCEPT`" TLSPSKIDENTITY=`"$TLSPSKIDENTITY`" TLSPSKFILE=`"$TLSPSKFILE`" TLSCAFILE=`"$TLSCAFILE`" TLSCRLFILE=`"$TLSCRLFILE`" TLSSERVERCERTISSUER=`"$TLSSERVERCERTISSUER`" TLSSERVERCERTSUBJECT=`"$TLSSERVERCERTSUBJECT`" TLSCERTFILE=`"$TLSCERTFILE`" TLSKEYFILE=`"$TLSKEYFILE`" ENABLEPATH=`"$ENABLEPATH`" SKIP=`"$SKIP`""
}

$packageArgs = @{
  packageName    = $packageName
  fileType       = 'MSI'
  url            = $url32
  url64bit       = $url64

  softwareName   = 'Zabbix Agent*'

  checksum       = $checksum32
  checksumType   = 'md5'
  checksum64     = $checksum64
  checksumType64 = 'md5'

  silentArgs     = $silentArgs
  validExitCodes = @(0, 3010, 1641)
}

Install-ChocolateyPackage @packageArgs
