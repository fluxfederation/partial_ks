require File.expand_path('../lib/partial_ks/version', __FILE__)

spec = Gem::Specification.new do |gem|
  gem.name         = 'partial_ks'
  gem.version      = PartialKs::VERSION
  gem.summary      = "Partial KS"
  gem.description  = <<-EOF
You know who

Internal Powershop-owned project, not licensed for third-party use without prior agreement.
EOF
  gem.has_rdoc     = false
  gem.author       = "Thong Kuah"
  gem.email        = "kuahyeow@gmail.com"
  gem.homepage     = "https://github.com/powershop/partial_ks"
  gem.license      = "MIT"

  gem.executables  = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files        = `git ls-files`.split("\n")
  gem.test_files   = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.require_path = "lib"

  gem.add_dependency "activerecord"
end
