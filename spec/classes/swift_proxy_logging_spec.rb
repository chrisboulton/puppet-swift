require 'spec_helper'

describe 'swift::proxy::proxy_logging' do

  let :facts do
    {
      :concat_basedir => '/var/lib/puppet/concat'
    }
  end

  let :pre_condition do
    'class { "concat::setup": }
     concat { "/etc/swift/proxy-server.conf": }'
  end

  let :fragment_file do
    "/var/lib/puppet/concat/_etc_swift_proxy-server.conf/fragments/27_swift_proxy-logging"
  end

  describe "when using default parameters" do
    it 'should not include any logging options' do
      verify_contents(subject, fragment_file,
        [
          '[filter:proxy-logging]',
          'use = egg:swift#proxy_logging',
        ]
      )
    end
  end

  describe "when overriding default parameters" do
    let :params do
      {
        :log_name                => 'custom_name',
        :log_facility            => 'LOG_LOCAL2',
        :log_level               => 'DEBUG',
        :log_address             => '/dev/null',
        :log_udp_host            => '127.0.0.1',
        :log_udp_port            => '514',
        :log_headers             => false,
        :log_headers_only        => ['Header-1', 'Header-2'],
        :reveal_sensitive_prefix => 16,
      }
    end
    it 'should build the fragment with correct parameters' do
      verify_contents(subject, fragment_file,
        [
          '[filter:proxy-logging]',
          'use = egg:swift#proxy_logging',
          'access_log_name = custom_name',
          'access_log_facility = LOG_LOCAL2',
          'access_log_level = DEBUG',
          'access_log_address = /dev/null',
          'access_log_udp_host = 127.0.0.1',
          'access_log_udp_port = 514',
          'access_log_headers = false',
          'access_log_headers_only = Header-1, Header-2',
          'reveal_sensitive_prefix = 16',
        ]
      )
    end
  end

end
