# zabbix-agent-chocolatey
This package installs the Zabbix agent using the pre-compiled files from [Zabbix SIA](https://www.zabbix.com/).

Executables are placed in "%ProgramFiles%\Zabbix Agent" and the zabbix_agentd.conf file is stored in "%ProgramData%\zabbix".

When new versions of the agent are installed, the original config is not overwritten but rather the version number of the new file is appended to the name. For example, if version 3.2.0 is installed and then upgraded to version 4.0.0 you will find the sample 4.0.0 config files saved as “zabbix_agentd-4.0.0.conf”.

The source code for this Chocolatey package can be found on [GitHub](https://github.com/zabbix/zabbix-agent-chocolatey). Please file any issues you find in the project's [Issue tracker](https://github.com/zabbix/zabbix-agent-chocolatey/issues).


## Release Notes


#### 2018-11-07 Release 4.0.0
* Bumped up to Zabbix 4.0.0
* Zabbix now places different arch into seperate zip files.

#### 2018-05-25 Release 3.4.6
* Bumped up to Zabbix 3.4.6.
* Fix logo for nuspec config.

#### 2017-03-01 Release 3.2.0
* Bumped up to Zabbix 3.2.0.
* Updated logo.
* Swiched repository references github.com/genebean back to github.com/zabbix.

#### 2017-03-01 Release 3.0.4
* Removed depreciated values from install scripts.
* Bumped up to Zabbix 3.0.4.
* Switched download url to https://.

#### 2015-03-22 Release 2.4.4  
* Moved config file from `$env:ProgramFiles\Zabbix Agent` to `$env:ProgramData\zabbix`.
* Reworked `.nuspec` file to adhere to Chocolatey standards.
* Reworked scripts so that all variables are at the top and so that they are less likely to throw
  errors or fail.
* Made syntax more consistent throughout scripts. For example, changed to use `Join-Path` everywhere
  instead of just in some place.
