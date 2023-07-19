# frozen_string_literal: true

require_relative "lib/szczupac/version"

Gem::Specification.new do |spec|
  spec.name = "szczupac"
  spec.version = Szczupac::VERSION
  spec.license = "MIT"
  spec.authors = ["Paweł Pacana"]
  spec.email = ["pawel.pacana@gmail.com"]
  spec.summary = "Generate matrix combinations for CI, that is all."
  spec.files = Dir["lib/**/*"]
  spec.require_paths = ["lib"]
  spec.metadata = {
    "changelog_uri" => "https://github.com/pawelpacana/szczupac/releases",
    "source_code_uri" => "https://github.com/pawelpacana/szczupac",
    "bug_tracker_uri" => "https://github.com/pawelpacana/szczupac/issues",
    "rubygems_mfa_required" => "true"
  }

  spec.required_ruby_version = ">= 3.0.0"
end
