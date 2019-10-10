# puppet-carbon_clickhouse

#### Table of Contents

- [puppet-carbon_clickhouse](#puppet-carbonclickhouse)
      - [Table of Contents](#table-of-contents)
  - [Description](#description)
  - [Setup](#setup)
    - [Setup Requirements](#setup-requirements)
    - [Beginning with carbon_clickhouse](#beginning-with-carbonclickhouse)
  - [Reference](#reference)
  - [Limitations](#limitations)
  - [Development](#development)

## Description

The carbon_clickhouse module installs, configures and manages the carbon-clickhouse service.

## Setup

### Setup Requirements

This module requires toml gem, which is used to translate Hash configuration to carbon-clickhouse toml format configuration files.
To install it you need to execute following command on your puppetmaster server:

```bash
sudo puppetserver gem install toml
```

### Beginning with carbon_clickhouse

To install a carbon-clickhouse with the default options:

`include 'carbon_clickhouse'`

To customize carbon-clickhouse configuration, you must also pass in an override hash:

```puppet
class { 'carbon_clickhouse':
  override_config => {
    'data' => {
      'path' => '/mnt/data/graphite/carbon-clickhouse'
    }
  }
}
```

If you want to customize clickhouse upload conguration, use `upload_config` option:

```puppet
class { 'carbon_clickhouse':
  upload_config => {
    'upload.graphite_reverse' => {
      'type'    => 'points-reverse',
      'table'   => 'graphite.graphite_reverse',
      'threads' => 1,
      'url'     => "http://graphite:${clickhouse_graphite_password}@localhost:8123",
      'timeout' => '1m0s',
    },
    'upload.graphite_index'   => {
      'type'      => 'index',
      'table'     => 'graphite.graphite_index',
      'threads'   => 1,
      'url'       => "http://graphite:${clickhouse_graphite_password}@localhost:8123",
      'timeout'   => '1m0s',
      'cache-ttl' => '12h0m0s',
    },
    'upload.graphite_tagged'  => {
      'type'      => 'tagged',
      'table'     => 'graphite.graphite_tagged',
      'threads'   => 1,
      'url'       => "http://graphite:${clickhouse_graphite_password}@localhost:8123",
      'timeout'   => '1m0s',
      'cache-ttl' => '12h0m0s',
    }
  }
}
```

## Reference
**Classes**

_Public Classes_

* [`carbon_clickhouse`](./REFERENCE.md#carbon_clickhouse): Installs and configures carbon-clickhouse.

_Private Classes_

* `carbon_clickhouse::config`: Private class for carbon-clickhouse configuration.
* `carbon_clickhouse::install`: Private class for managing carbon-clickhouse package.
* `carbon_clickhouse::params`: Private class for setting default carbon-clickhouse parameters.
* `carbon_clickhouse::service`: Private class for managing the carbon-clickhouse service.

**Functions**

* [`carbon_clickhouse_config`](./REFERENCE.md#carbon_clickhouse_config): Convert hash to carbon-clickhouse TOML config.

## Limitations

For a list of supported operating systems, see [metadata.json](https://github.com/MaxFedotov/puppet-carbon_clickhouse/blob/master/metadata.json)

## Development

Please feel free to fork, modify, create issues, bug reports and pull requests.