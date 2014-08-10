class swift::proxy::tempauth(
  $users = {
    'admin_admin'   => ['admin', '.admin', '.reseller_admin'],
    'test_tester'   => ['testing', '.admin'],
    'test2_tester2' => ['testing2', '.admin'],
    'test_tester3'  => ['testing3']
  },
  $users64 = {}
) {
  validate_hash($users)
  validate_hash($users64)

  concat::fragment { 'swift-proxy-swauth':
    target  => '/etc/swift/proxy-server.conf',
    content => template('swift/proxy/tempauth.conf.erb'),
    order   => '01',
  }

}
