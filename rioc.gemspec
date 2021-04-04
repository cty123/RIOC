require_relative 'lib/rioc/version'

Gem::Specification.new do |spec|
  spec.name = 'rioc'
  spec.version = Rioc::VERSION
  spec.authors = ['cty']
  spec.email = ['ctychen2216@gmail.com']

  spec.summary = 'Ruby IoC container framework'
  spec.description = 'Ruby Ioc container framework'
  spec.homepage = 'https://github.com/cty123/RIOC'
  spec.license = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.3.0')

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/cty123/RIOC'
  spec.metadata['changelog_uri'] = 'https://github.com/cty123/RIOC/blob/master/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
end
