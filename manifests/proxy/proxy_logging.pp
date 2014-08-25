#
# Configure swift proxy-logging.
#
# == Authors
#
#   Joe Topjian joe@topjian.net
#
class swift::proxy::proxy_logging(
  $log_name                = 'UNSET',
  $log_facility            = 'UNSET',
  $log_level               = 'UNSET',
  $log_address             = 'UNSET',
  $log_udp_host            = 'UNSET',
  $log_udp_port            = 'UNSET',
  $log_headers             = 'UNSET',
  $log_headers_only        = 'UNSET',
  $reveal_sensitive_prefix = 'UNSET'
) {
  concat::fragment { 'swift_proxy-logging':
    target  => '/etc/swift/proxy-server.conf',
    content => template('swift/proxy/proxy-logging.conf.erb'),
    order   => '27',
  }
}
