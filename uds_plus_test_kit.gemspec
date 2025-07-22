require_relative 'lib/uds_plus_test_kit/version'

Gem::Specification.new do |spec|
  spec.name          = 'uds_plus_test_kit'
  spec.version       = UDSPlusTestKit::VERSION
  spec.authors       = ['Leap Orbit']
  spec.date          = Time.now.utc.strftime('%Y-%m-%d')
  spec.summary       = 'UDS Plus Test Kit'
  spec.description   = 'UDS Plus Test Kit'
  spec.homepage      = 'https://github.com/inferno-framework/uds-plus-test-kit'
  spec.license       = 'Apache-2.0'
  spec.add_runtime_dependency 'inferno_core', '~> 1.0', '>= 1.0.2'
  spec.add_development_dependency 'database_cleaner-sequel', '~> 1.8'
  spec.add_development_dependency 'factory_bot', '~> 6.1'
  spec.add_development_dependency 'rspec', '~> 3.10'
  spec.add_development_dependency 'webmock', '~> 3.11'
  spec.required_ruby_version = Gem::Requirement.new('>= 3.1.2')
  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/inferno-framework/uds-plus-test-kit'
  spec.metadata['inferno_test_kit'] = 'true'
  spec.files         = `[ -d .git ] && git ls-files -z lib config/presets LICENSE`.split("\x0")

  spec.require_paths = ['lib']
end
