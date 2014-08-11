require 'spec_helper'

describe 'swift::proxy::gatekeeper' do

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
    "/var/lib/puppet/concat/_etc_swift_proxy-server.conf/fragments/34_swift_gatekeeper"
  end

  describe "when using default parameters" do
    it 'should build the fragment with correct parameters' do
      verify_contents(subject, fragment_file,
        [
          '[filter:gatekeeper]',
          'use = egg:swift#gatekeeper',
        ]
      )
    end
  end
end
