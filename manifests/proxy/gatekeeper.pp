#
# Configure swift gatekeeper.
#
# == Examples
#
#  include swift::proxy::gatekeeper
#
# == Authors
#
#   Xingchao Yu yuxcer@gmail.com
#
# == Copyright
#
# Copyright 2014 UnitedStack licensing@unitedstack.com
#

class swift::proxy::gatekeeper {
  concat::fragment { 'swift_gatekeeper':
    target  => '/etc/swift/proxy-server.conf',
    content => template('swift/proxy/gatekeeper.conf.erb'),
    order   => '34',
  }

}
