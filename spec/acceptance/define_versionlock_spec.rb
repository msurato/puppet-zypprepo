require 'spec_helper_acceptance'

describe 'zypprepo::versionlock define' do
  context 'default parameters' do
    # Using puppet_apply as a helper
    it 'must work idempotently with no errors' do
      pp = <<-EOS
      zypprepo::versionlock{ 'bash-4.4-9.10.1.*': }
      zypprepo::versionlock{ 'java-1.7.0-openjdk-1.7.0.121-2.6.8.0.3.x86_64': }
      EOS
      # Run it twice and test for idempotency
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes:  true)
    end
    describe file('/etc/zypprepo/pluginconf.d/versionlock.list') do
      it { is_expected.to be_file }
      it { is_expected.to contain 'bash-4.4-9.10.1.*' }
      it { is_expected.to contain 'java-1.7.0-openjdk-1.7.0.121-2.6.8.0.3.x86_64' }
    end
    # Run zypper and see that a lock is defined for bash
    shell('zypper ll |  grep bash |  awk -F \| "{print $2}" |  grep -v bash', acceptable_exit_codes: [1])
  end
end
