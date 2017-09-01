require File.expand_path('../lib/partial_ks/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name         = 'partial_ks'
  gem.version      = PartialKs::VERSION
  gem.summary      = "Partial KS"
  gem.description  = <<-EOF
A library to use kitchen-sync to sync a subset of your database
EOF
  gem.has_rdoc     = false
  gem.author       = "Thong Kuah"
  gem.email        = "kuahyeow@gmail.com"
  gem.homepage     = "https://github.com/fluxfederation/partial_ks"
  gem.license      = "MIT"

  gem.executables  = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files        = `git ls-files`.split("\n")
  gem.test_files   = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.require_path = "lib"

  gem.add_dependency "activerecord", ">= 4.2.0"
  gem.add_development_dependency "rake"
  gem.add_development_dependency "sqlite3"
end
