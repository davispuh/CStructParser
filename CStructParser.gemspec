# frozen_string_literal: true

require_relative 'lib/cstruct_parser/version'

Gem::Specification.new do |spec|
  spec.name     = 'CStructParser'
  spec.version  = CStructParser::VERSION
  spec.authors  = ['Dāvis Mosāns']

  spec.summary  = 'Parse C structs into usable Ruby structs such as BinData'
  spec.homepage = 'https://github.com/davispuh/CStructParser'
  spec.license  = 'UNLICENSE'
  spec.required_ruby_version = '>= 3.2.0'

  spec.metadata['homepage_uri']    = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/davispuh/CStructParser'
  spec.metadata['changelog_uri']   = 'https://github.com/davispuh/CStructParser/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ Gemfile .gitignore .rspec spec/])
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'ffi_generator'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'yard'

end
