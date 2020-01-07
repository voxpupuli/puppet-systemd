include RspecPuppetFacts
add_custom_fact :systemd_internal_services, YAML.load(File.read(File.expand_path('../default_module_facts.yaml', __FILE__)))
