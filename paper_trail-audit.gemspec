$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "paper_trail-audit/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "paper_trail-audit"
  s.version     = PaperTrailAudit::VERSION
  s.authors     = ["Matthew Chang"]
  s.email       = ["mjchang07@gmail.com"]
  s.summary       = "Adds column level auditing to a paper trail tracked model"
  s.license     = "MIT"
  s.homepage    = "https://github.com/MatthewChang/PaperTrailAudit"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency 'rails', '~> 4'
  s.add_dependency 'paper_trail', '~> 5'
  s.add_development_dependency "sqlite3", "~> 1.3"
  s.add_development_dependency "rspec-rails", '~> 3'
end
