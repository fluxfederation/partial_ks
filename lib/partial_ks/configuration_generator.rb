# Given an initial table graph
# goes through each table not already in the table graph,
# and attempts to automatically populate the table into the table graph
class PartialKs::ConfigurationGenerator
  attr_reader :manual_configuration, :table_names

  def initialize(manual_configuration, table_names: nil)
    @manual_configuration = manual_configuration
    @table_names = table_names || ActiveRecord::Base.connection.tables
  end

  def call
    @filtered_tables ||= filtered_tables
  end

  protected
  def all_tables
    @all_tables ||= @table_names.map {|table_name| PartialKs::Table.new(table_name) }.select(&:model?).index_by(&:table_name)
  end

  def filtered_tables
    synced_tables = {}

    manual_configuration.each do |table_name_or_model, specified_parent_model, filter_for_table|
      table_name = table_name_or_model.is_a?(String) ? table_name_or_model : table_name_or_model.table_name
      next unless all_tables[table_name]

      parent_model = specified_parent_model
      synced_tables[table_name] = PartialKs::FilteredTable.new(all_tables[table_name], parent_model, custom_filter_relation: filter_for_table)
    end

    all_tables.each do |table_name, table|
      next if synced_tables[table_name]

      begin
        inferrer = PartialKs::ParentInferrer.new(table)
        #TODO get rid of try!
        parent_model = all_tables[inferrer.inferred_parent_table].try!(:model)
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
