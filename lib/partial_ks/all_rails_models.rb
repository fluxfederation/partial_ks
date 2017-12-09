module PartialKs
  def self.all_rails_models
    if defined?(Rails) && Rails.respond_to?(:application)
      ::Rails.application.eager_load!
      ::Rails::Engine.subclasses.map(&:eager_load!)
    end

    concrete_classes.map(&:base_class).uniq
  end

  private
  def self.concrete_classes
    ActiveRecord::Base.descendants.reject {|klass| klass.abstract_class? || !klass.table_exists?}
  end
end
