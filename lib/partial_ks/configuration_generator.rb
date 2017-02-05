module PartialKs
  # TODO ModelList ?
  class ConfigurationGenerator
    attr_reader :manual_configuration

    def initialize(manual_configuration)
      @manual_configuration = manual_configuration
    end

    def all
      tables_already_present = manual_configuration.map(&:first).map(&:table_name)
      manual_configuration + automatic_configuration.reject{|model, _| tables_already_present.include?(model.table_name) }
    end

    private
    def automatic_configuration
      PartialKs.all_rails_models.map do |model|
        table = PartialKs::Table.new(model)
        [table.model, table.inferred_parent_class]
      end
    end
  end
end
