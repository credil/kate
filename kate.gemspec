# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "kate"
  s.version     = "1.1.2"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Michael Richardson"]
  s.email       = ["mcr@credil.org"]
  s.homepage    = "http://github.com/credil/kate"
  s.summary     = %q{A set of libraries for talking to Paypal}
  s.description = %q{Kate is an extraction of the paypal SDK vendor code, fixed up.}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "rails", "~> 3.1"
end
