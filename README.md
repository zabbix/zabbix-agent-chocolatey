# zabbix-agent2

This repository is DEPRECATED and available in READ ONLY mode.
No more chocolatey packages will be created

## Changelog

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
