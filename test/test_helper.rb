require 'minitest/autorun'
require 'partial_ks'

require 'setup_models'
ActiveRecord::Base.configurations = YAML::load(IO.read(File.join(File.dirname(__FILE__), "database.yml")))
ActiveRecord::Base.establish_connection ActiveRecord::Base.configurations['test']
load(File.join(File.dirname(__FILE__), "/schema.rb"))
