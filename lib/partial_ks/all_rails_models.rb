module PartialKs
  def self.all_rails_models
    if defined?(Rails)
      ::Rails.application.eager_load!
      ::Rails::Engine.subclasses.map(&:eager_load!)
    end
    ActiveRecord::Base.direct_descendants
  end
end
