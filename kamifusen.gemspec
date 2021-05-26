# frozen_string_literal: true

require_relative "lib/kamifusen/version"

Gem::Specification.new do |spec|
  spec.name          = "kamifusen"
  spec.version       = Kamifusen::VERSION
  spec.authors       = ["Sébastien Moulène", "Arnaud Levy"]
  spec.email         = ["sebousan@gmail.com", "contact@arnaudlevy.com"]

  spec.summary       = "Images, light as balloons"
  spec.description   = "Image multiple optimizing: webp, srcset, server side resize."
  spec.homepage      = "https://github.com/sebousan/kamifusen"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.4.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/sebousan/kamifusen"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rails"
  spec.add_dependency "image_processing"

  spec.add_development_dependency "listen"
  spec.add_development_dependency "sqlite3"
end
