$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "paper_trail_audit/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "paper_trail-audit"
  s.version     = PaperTrailAudit::VERSION
  s.authors     = ["Matthew Chang"]
  s.email       = ["mjchang07@gmail.com"]
  s.summary       = "Adds column level auditing to a paper trail tracked model"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.6"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "byebug"
  s.add_development_dependency "paper_trail"
  s.add_runtime_dependency 'paper_trail'
end
