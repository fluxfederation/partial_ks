module PartialKs
  class ModelsList
    attr_reader :manual_configuration

    def initialize(manual_configuration)
      @manual_configuration = manual_configuration
    end

    def all
      @all ||= manual_configuration + automatic_configuration_except_manual
    end

    def issues
      all.select{|model, parent| parent.is_a?(PartialKs::MultiParent)}
    end

    private
    def automatic_configuration_except_manual
      tables_already_present = manual_configuration.map(&:first).map(&:table_name)

      PartialKs.all_rails_models.reject{|model| tables_already_present.include?(model.table_name) }.map do |model|
        table = PartialKs::Table.new(model)
        [table.model, table.inferred_parent_class]
      end
    end
  end
end
