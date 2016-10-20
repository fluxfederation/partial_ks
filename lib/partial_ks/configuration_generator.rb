# Given an initial table graph
# goes through each table not already in the table graph,
# and attempts to automatically populate the table into the table graph
class PartialKs::ConfigurationGenerator
  attr_reader :table_graph, :ignored_table_names

  def initialize(table_graph, ignored_table_names: [])
    @table_graph = table_graph
    @ignored_table_names = ignored_table_names
  end

  def call
    @auto_constructed_table_graph ||= auto_construct_table_graph
  end

  protected
  def all_tables
    @all_tables ||= (ActiveRecord::Base.connection.tables - ignored_table_names).map {|table_name| PartialKs::Table.new(table_name) }.select(&:model?).index_by(&:table_name)
  end

  def auto_construct_table_graph
    synced_tables = {}

    table_graph.each do |table_name, parent_table, table_graph|
      next unless all_tables[table_name]

      synced_tables[table_name] = [table_name, parent_table, table_graph]
    end

    all_tables.each do |table_name, table|
      next if synced_tables[table_name]
      next unless table.top_level_table?

      synced_tables[table_name] = [table_name, nil]
    end

    all_tables.each do |table_name, table|
      next if synced_tables[table_name]
      next unless table.non_nullable_parent_tables.size == 1

      parent_table_name, _, _ = synced_tables[table.non_nullable_parent_tables.only]
      parent_table = all_tables[parent_table_name] if parent_table_name
      next unless parent_table

      synced_tables[table.table_name] = [table_name, parent_table.model]
    end

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
