# Given an initial table graph
# goes through each table not already in the table graph,
# and attempts to automatically populate the table into the table graph
module PartialKs
  class ConfigurationGenerator
    attr_reader :manual_configuration, :models

    def initialize(manual_configuration, models: nil)
      @manual_configuration = manual_configuration
      @models = models || PartialKs.all_rails_models
    end

    def call
      @filtered_tables ||= filtered_tables
    end

    protected
    def all_tables
      @all_tables ||= models.map {|model| PartialKs::Table.new(model) }.select(&:model?).index_by(&:table_name)
    end

    def filtered_tables
      synced_tables = {}

      manual_configuration.each do |model, specified_parent_model, filter_for_table|
        table_name = model.table_name
        next unless all_tables[table_name]

        parent_model = specified_parent_model
        synced_tables[table_name] = PartialKs::FilteredTable.new(all_tables[table_name], parent_model, custom_filter_relation: filter_for_table)
      end

      all_tables.each do |table_name, table|
        next if synced_tables[table_name]

        begin
          inferrer = PartialKs::ParentInferrer.new(table)
          parent_model = inferrer.inferred_parent_class
          synced_tables[table_name] = PartialKs::FilteredTable.new(table, parent_model)
        rescue PartialKs::ParentInferrer::CannotInfer
          next
        end

      end

      # TODO remove this side effect. Maybe yield or a different method call ?
      puts "***************"
      remaining_size = 0
      all_tables.each do |table_name, table|
        next if synced_tables[table_name]

        puts "#{table.table_name} - #{table.parent_tables.join(',')}"
        remaining_size += 1
      end
      puts "WARNING: #{remaining_size} tables has no configuration"

      synced_tables.values
    end

  end
end
