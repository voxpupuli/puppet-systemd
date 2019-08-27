include RspecPuppetFacts
add_custom_fact :systemd_internal_services, YAML.safe_load(File.read(File.expand_path('../default_module_facts.yaml', __FILE__)))

# HACK: to enable all the expect syntax (like allow_any_instance_of) in rspec-puppet examples
RSpec::Mocks::Syntax.enable_expect(RSpec::Puppet::ManifestMatchers)

RSpec.configure do |config|
  config.mock_with :rspec

  config.before :each do
    # Ensure that we don't accidentally cache facts and environment between
    # test cases.  This requires each example group to explicitly load the
    # facts being exercised with something like
    # Facter.collection.loader.load(:ipaddress)
    Facter.clear
    Facter.clear_messages

    RSpec::Mocks.setup
  end

  config.after :each do
    RSpec::Mocks.verify
    RSpec::Mocks.teardown
  end
end
