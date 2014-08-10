require 'spec_helper'

describe 'swift::proxy::tempauth' do

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
    "/var/lib/puppet/concat/_etc_swift_proxy-server.conf/fragments/01_swift-proxy-swauth"
  end

  describe "when using default parameters" do
    it 'should build the fragment with correct parameters' do
      verify_contents(subject, fragment_file,
        [
          '[filter:tempauth]',
          'use = egg:swift#tempauth',
          'user_admin_admin = admin .admin .reseller_admin',
          'user_test_tester = testing .admin',
          'user_test2_tester2 = testing2 .admin',
          'user_test_tester3 = testing3',
        ]
      )
    end
  end

  describe "when overriding default parameters" do
    let :params do
      {
        :users => {
          'testing1_testing2' => ['token', '.admin'],
          'another_test'      => 'token2',
        },
        :users64 => {
          'xxxxxxxx'          => ['token3'],
        },
      }
    end
    it 'should build the fragment with correct parameters' do
      verify_contents(subject, fragment_file,
        [
          '[filter:tempauth]',
          'use = egg:swift#tempauth',
          'user_testing1_testing2 = token .admin',
          'user_another_test = token2',
          'user64_xxxxxx = token3',
        ]
      )
    end
  end

end
