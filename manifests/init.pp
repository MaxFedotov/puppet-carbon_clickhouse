# @summary
#   Installs and configures carbon-clickhouse.
#
# @example Install carbon-clickhouse.
#   class { 'carbon_clickhouse':
#     package_name   => 'carbon-clickhouse',
#     user           => 'carbon',
#     group          => 'carbon',
#   }
#
# @param package_name
#   Name of carbon-clickhouse package to install. Defaults to 'carbon-clickhouse'.
# @param package_ensure
#   Whether the carbon-clickhouse package should be present, absent or specific version. 
#   Valid values are 'present', 'absent' or 'x.y.z'. Defaults to 'present'.
# @param manage_package
#   Whether to manage carbon-clickhouse package. Defaults to 'true'.
# @param package_install_options
#   Array of install options for managed package resources. Appropriate options are passed to package manager.
# @param manage_config
#   Whether the carbon-clickhouse configurations files should be managed. Defaults to 'true'.
# @param config_dir
#   Directory where carbon-clickhouse configuration files will be stored. Defaults to '/etc/carbon-clickhouse'.
# @param config_file
#   Name of the file, where carbon-clickhouse configuration will be stored. Defaults to 'carbon-clickhouse.conf'.
# @param user
#   Owner for carbon-clickhouse configuration and data directories. Defaults to 'carbon-clickhouse'.
# @param group
#   Group for carbon-clickhouse configuration and data directories. Defaults to 'carbon-clickhouse'.
# @param override_config
#   Hash[String, Any] of override configuration options to pass to carbon-clickhouse configuration file.
# @param upload_config
#   Hash[String, Any] of Clickhouse upload configuration options to pass to carbon-clickhouse configuration file. 
# @param service_name
#   Name of the carbon-clickhouse service. Defaults to 'carbon-clickhouse'.
# @param service_ensure
#   Specifies whether carbon-clickhouse service should be running. Defaults to 'running'.
# @param service_enabled
#   Specifies whether carbon-clickhouse service should be enabled. Defaults to 'true'.
# @param manage_service
#   Specifies whether carbon-clickhouse service should be managed. Defaults to 'true'.
# @param restart
#   Specifies whether carbon-clickhouse service should be restated when configuration changes. Defaults to 'true'.
# @param enable_logrotate
#   Specifies whether logrotate rules should be creatd for carbon-clickhouse logs. Defaults to 'true'.
#
class carbon_clickhouse (
  String $package_name                          = $carbon_clickhouse::params::package_name,
  String $package_ensure                        = $carbon_clickhouse::params::package_ensure,
  Boolean $manage_package                       = $carbon_clickhouse::params::manage_package,
  Array[String] $package_install_options        = $carbon_clickhouse::params::package_install_options,
  Boolean $manage_config                        = $carbon_clickhouse::params::manage_config,
  Stdlib::Unixpath $config_dir                  = $carbon_clickhouse::params::config_dir,
  String $config_file                           = $carbon_clickhouse::params::config_file,
  String $user                                  = $carbon_clickhouse::params::user,
  String $group                                 = $carbon_clickhouse::params::group,
  Optional[Hash[String, Any]] $override_config  = {},
  Hash[String, Any] $upload_config              = $carbon_clickhouse::params::upload_config,
  String $service_name                          = $carbon_clickhouse::params::service_name,
  Stdlib::Ensure::Service $service_ensure       = $carbon_clickhouse::params::service_ensure,
  Boolean $service_enabled                      = $carbon_clickhouse::params::service_enabled,
  Boolean $manage_service                       = $carbon_clickhouse::params::manage_service,
  Boolean $restart                              = $carbon_clickhouse::params::restart,
  Boolean $enable_logrotate                     = $carbon_clickhouse::params::enable_logrotate,
) inherits carbon_clickhouse::params {

  if $restart {
    Class['carbon_clickhouse::config']
    ~> Class['carbon_clickhouse::service']
  }

  anchor { 'carbon_clickhouse::start': }
  -> class { 'carbon_clickhouse::install': }
  -> class { 'carbon_clickhouse::config': }
  -> class { 'carbon_clickhouse::service': }
  -> anchor { 'carbon_clickhouse::end': }
}
