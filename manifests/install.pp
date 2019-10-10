# @summary 
#   Private class for managing carbon-clickhouse package.
#
# @api private
#
class carbon_clickhouse::install {

  if !defined(Group[$carbon_clickhouse::group]) {
    group { $carbon_clickhouse::group:
      ensure => present,
    }
  }

  if !defined(User[$carbon_clickhouse::user]) {
    user { $carbon_clickhouse::user:
      ensure => present,
      groups => $carbon_clickhouse::group,
    }
  }

  if $carbon_clickhouse::manage_package {
    package { $carbon_clickhouse::package_name:
      ensure          => $carbon_clickhouse::package_ensure,
      install_options => $carbon_clickhouse::package_install_options,
    }
  }
}
