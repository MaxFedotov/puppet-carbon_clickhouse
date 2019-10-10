# @summary
#   Private class for carbon-clickhouse configuration.
#
# @api private
#
class carbon_clickhouse::config {

  case true {
    $facts['processorcount'] <= 2 : { $max_cpu = $facts['processorcount'] }
    default: { $max_cpu = $facts['processorcount'] - 2 }
  }
# taken from https://github.com/lomik/graphite-clickhouse-tldr/blob/master/carbon-clickhouse.conf
  $default_config = {
    'common'     => {
      'metric-prefix'   => 'carbon.agents.{host}',
      'metric-endpoint' => 'local',
      'metric-interval' => '1m0s',
      'max-cpu'         => $max_cpu,
    },
    'logging'    => {
      'file'  => '/var/log/carbon-clickhouse/carbon-clickhouse.log',
      'level' => 'info',
    },
    'data'       => {
      'path'                => '/var/lib/carbon-clickhouse',
      'chunk-interval'      => '1s',
      'chunk-auto-interval' => '5:5s,10:60s',
    },
    'udp'        => {
      'listen'  => ':2003',
      'enabled' => true,
    },
    'tcp'        => {
      'listen'  => ':2003',
      'enabled' => true,
    },
    'pickle'     => {
      'listen'  => ':2004',
      'enabled' => true,
    },
    'prometheus' => {
      'listen'  => ':2006',
      'enabled' => true,
    },
    'grpc'       => {
      'listen'  => ':2006',
      'enabled' => false,
    },
    'pprof'      => {
      'listen'  => 'localhost:7007',
      'enabled' => false,
    },
  }

  $config = deep_merge($default_config, $carbon_clickhouse::upload_config, $carbon_clickhouse::override_config)
  $log_dir = dirname($config['logging']['file'])

  file { [$config['data']['path'], $log_dir]:
    ensure => directory,
    owner  => $carbon_clickhouse::user,
    group  => $carbon_clickhouse::group,
    mode   => '2755',
  }

  if $carbon_clickhouse::manage_config {
    file { $carbon_clickhouse::config_dir:
      ensure => directory,
      owner  => $carbon_clickhouse::user,
      group  => $carbon_clickhouse::group,
      mode   => '2755',
    }

    file { "${carbon_clickhouse::config_dir}/${carbon_clickhouse::config_file}":
      content => carbon_clickhouse_config($config),
      owner   => $carbon_clickhouse::user,
      group   => $carbon_clickhouse::group,
      mode    => '2755',
      require => File[$carbon_clickhouse::config_dir],
    }
  }

  if $carbon_clickhouse::enable_logrotate {
    logrotate::rule { 'carbon-clickhouse-logrotate':
      path         => [ "${log_dir}/*.log" ],
      missingok    => true,
      copytruncate => true,
      su           => true,
      su_user      => $carbon_clickhouse::user,
      su_group     => $carbon_clickhouse::group,
      rotate       => 5,
      rotate_every => 'daily',
      compress     => false,
      require      => File[$log_dir],
    }
  }
}
