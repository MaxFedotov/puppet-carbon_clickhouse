# @summary
#   Private class for setting default carbon-clickhouse parameters.
#
# @api private
#
class carbon_clickhouse::params {
  $package_name             = 'carbon-clickhouse'
  $package_ensure           = 'present'
  $manage_package           = true
  $package_install_options  = []
  $manage_config            = true
  $config_dir               = '/etc/carbon-clickhouse'
  $config_file              = 'carbon-clickhouse.conf'
  $user                     = 'carbon-clickhouse'
  $group                    = 'carbon-clickhouse'
  $service_name             = 'carbon-clickhouse'
  $service_ensure           = 'running'
  $service_enabled          = true
  $manage_service           = true
  $restart                  = true
  $enable_logrotate         = true
  $upload_config            = {
    'upload.graphite_reverse' => {
      'type'    => 'points-reverse',
      'table'   => 'graphite_reverse',
      'threads' => 1,
      'url'     => 'http://clickhouse:8123/',
      'timeout' => '1m0s',
    },
    'upload.graphite_index'   => {
      'type' => 'index',
      'table' => 'graphite_index',
      'threads' => 1,
      'url' => 'http://clickhouse:8123/',
      'timeout' => '1m0s',
      'cache-ttl' => '12h0m0s',
    },
    'upload.graphite_tagged'  => {
      'type'      => 'tagged',
      'table'     => 'graphite_tagged',
      'threads'   => 1,
      'url'       => 'http://clickhouse:8123/',
      'timeout'   => '1m0s',
      'cache-ttl' => '12h0m0s',
    },
  }
}
