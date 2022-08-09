# zabbix-agent2

## Overview

Zabbix agent 2 is a new generation of Zabbix agent and may be used in place of Zabbix agent. Zabbix agent 2 has been developed to:

reduce the number of TCP connections
provide improved concurrency of checks
be easily extendible with plugins. A plugin should be able to:
provide trivial checks consisting of only a few simple lines of code
provide complex checks consisting of long-running scripts and standalone data gathering with periodic sending back of the data
be a drop-in replacement for Zabbix agent (in that it supports all the previous functionality)
Agent 2 is written in Go (with some C code of Zabbix agent reused). A configured Go environment with a currently supported Go version is required for building Zabbix agent 2.

Agent 2 does not have built-in daemonization support on Linux; it can be run as a Windows service.

## Changelog

* 2022-08-09 Version 6.2.1

* 2021-07-27 Version 5.2.7

* 2021-04-21 Version 5.2.6

## Usage

### Direct

```cmd
choco install zabbix-agent2 -y
```

### YAML (Foreman, puppetlabs/chocolatey module)

```yaml
zabbix-agent2:
  ensure: latest
  provider: chocolatey
```

or

```yaml
zabbix-agent2:
  ensure: latest
```
