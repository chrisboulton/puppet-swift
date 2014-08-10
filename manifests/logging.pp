class swift::logging(
  $log_name                       = 'swift',
  $log_facility                   = 'LOG_LOCAL2',
  $log_level                      = 'INFO',
  $log_address                    = '/dev/log',
  $log_max_line_length            = 0,
  $log_custom_handlers            = '',
  $log_udp_host                   = '',
  $log_udp_port                   = 514,
  $log_statsd_host                = '',
  $log_statsd_port                = 8125,
  $log_statsd_default_sample_rate = 1.0,
  $log_statsd_sample_rate_factor  = 1.0,
  $log_statsd_metric_prefix       = ''
) {
}