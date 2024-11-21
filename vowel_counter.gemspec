# frozen_string_literal: true

require_relative "lib/vowel_counter/version"

Gem::Specification.new do |spec|
  spec.name = "vowel_counter"
  spec.version = VowelCounter::VERSION
  spec.authors = ["LesieBarbie"]
  spec.email = ["olesia.pushkina@student.karazin.ua"]

  spec.summary = "A simple gem to count vowels in a string."
  spec.description = "VowelCounter is a Ruby gem that provides an easy way to count the number of vowels in a given string. Perfect for text processing tasks."
  spec.homepage = "https://github.com/LesieBarbie/vowel_counter"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/LesieBarbie/vowel_counter"
  spec.metadata["changelog_uri"] = "https://github.com/LesieBarbie/vowel_counter/CHANGELOG.md"

  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "rspec", "~> 3.12"
end
