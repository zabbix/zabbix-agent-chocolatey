# zabbix-agent2

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
