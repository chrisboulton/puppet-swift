#
# I am not sure if this is the right name
#   - should it be device?
#
#  name - is going to be port
define swift::storage::server(
  $type,
  $storage_local_net_ip,
  $devices                        = '/srv/node',
  $owner                          = 'swift',
  $group                          = 'swift',
  $max_connections                = 25,
  $pipeline                       = ["${type}-server"],
  $mount_check                    = false,
  $user                           = 'swift',
  $workers                        = '1',
  $allow_versions                 = false,
  $replicator_concurrency         = $::processorcount,
  $updater_concurrency            = $::processorcount,
  $reaper_concurrency             = $::processorcount,
  $log_facility                   = $::swift::logging::log_facility,
  $log_level                      = $::swift::logging::log_level,
  $log_address                    = $::swift::logging::log_address,
  $log_max_line_length            = $::swift::logging::log_max_line_length,
  $log_custom_handlers            = $::swift::logging::log_custom_handlers,
  $log_udp_host                   = $::swift::logging::log_udp_host,
  $log_udp_port                   = $::swift::logging::log_udp_port,
  $log_statsd_host                = $::swift::logging::log_statsd_host,
  $log_statsd_port                = $::swift::logging::log_statsd_port,
  $log_statsd_default_sample_rate = $::swift::logging::log_statsd_default_sample_rate,
  $log_statsd_sample_rate_factor  = $::swift::logging::log_statsd_sample_rate_factor,
  $log_statsd_metric_prefix       = $::swift::logging::log_statsd_metric_prefix,
  # this parameters needs to be specified after type and name
  $config_file_path               = "${type}-server/${name}.conf"
) {
  # Warn if ${type-server} isn't included in the pipeline
  if is_array($pipeline) {
    if !member($pipeline, "${type}-server") {
      warning("swift storage server ${type} must specify ${type}-server")
    }
  } elsif $pipeline != "${type}-server" {
    warning("swift storage server ${type} must specify ${type}-server")
  }

  include "swift::storage::${type}"
  include concat::setup

  validate_re($name, '^\d+$')
  validate_re($type, '^object|container|account$')
  validate_array($pipeline)
  validate_bool($allow_versions)
  # TODO - validate that name is an integer

  validate_string($log_facility)
  validate_string($log_level)
  validate_string($log_address)
  validate_re($log_max_line_length, '^\d$')
  validate_string($log_custom_handlers)
  validate_string($log_udp_host)
  validate_re($log_udp_port, '\d')
  validate_string($log_statsd_host)
  validate_re($log_statsd_port, '\d')
  validate_re($log_statsd_default_sample_rate, '[\d\.]+')
  validate_re($log_statsd_sample_rate_factor, '[\d\.]+')
  validate_string($log_statsd_metric_prefix)

  $bind_port = $name

  rsync::server::module { $type:
    path            => $devices,
    lock_file       => "/var/lock/${type}.lock",
    uid             => $owner,
    gid             => $group,
    max_connections => $max_connections,
    read_only       => false,
  }

  concat { "/etc/swift/${config_file_path}":
    owner   => $owner,
    group   => $group,
    notify  => Service["swift-${type}", "swift-${type}-replicator"],
    require => Package['swift'],
    mode    => 640,
  }

  $required_middlewares = split(
    inline_template(
      "<%=
        (@pipeline - ['${type}-server']).collect do |x|
          'Swift::Storage::Filter::' + x.capitalize + '[${type}]'
        end.join(',')
      %>"), ',')

  # you can now add your custom fragments at the user level
  concat::fragment { "swift-${type}-${name}":
    target  => "/etc/swift/${config_file_path}",
    content => template("swift/${type}-server.conf.erb"),
    order   => '00',
    # require classes for each of the elements of the pipeline
    # this is to ensure the user gets reasonable elements if he
    # does not specify the backends for every specified element of
    # the pipeline
    before  => $required_middlewares,
    require => Package['swift'],
  }
}
