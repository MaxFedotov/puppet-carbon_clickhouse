# @summary 
#   Private class for managing the carbon-clickhouse service.
#
# @api private
#
class carbon_clickhouse::service {

  if $carbon_clickhouse::manage_service {
    systemd::unit_file { 'carbon-clickhouse.service':
      content => epp("${module_name}/carbon-clickhouse.service.epp",
      {
        'user'        => $carbon_clickhouse::user,
        'group'       => $carbon_clickhouse::group,
        'config_file' => "${carbon_clickhouse::config_dir}/${carbon_clickhouse::config_file}"
      }),
    }

    if $carbon_clickhouse::manage_package {
      $service_require = [Package[$carbon_clickhouse::package_name], Systemd::Unit_file['carbon-clickhouse.service']]
    } else {
      $service_require = Systemd::Unit_file['carbon-clickhouse.service']
    }

    service { $carbon_clickhouse::service_name:
      ensure  => $carbon_clickhouse::service_ensure,
      enable  => $carbon_clickhouse::service_enabled,
      require => $service_require,
    }

    if $carbon_clickhouse::manage_config {
      File["${carbon_clickhouse::config_dir}/${carbon_clickhouse::config_file}"] -> Service[$carbon_clickhouse::service_name]
    }
  }
}
