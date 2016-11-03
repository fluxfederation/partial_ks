class PartialKs::Runner
  attr_reader :table_graphs

  def initialize(table_graphs)
    @table_graphs = table_graphs
  end

  def run!
    each_generation do |generation|
      tables_to_filter = {}
      table_names = []

      generation.each do |table_name, filter_config, depth|
        table_names << table_name

        if !filter_config.nil?
          if filter_config.is_a?(ActiveRecord::Relation) || filter_config.respond_to?(:where_sql)
            only_filter = filter_config.where_sql.to_s.sub("WHERE", "")
          elsif filter_config.is_a?(String)
            only_filter = filter_config
          else
            only_filter = "#{filter_config.to_s.foreign_key} IN (#{[0, *filter_config.pluck(:id)].join(',')})"
          end

          tables_to_filter[table_name] = {"only" => only_filter}
        end
      end

      yield tables_to_filter, table_names
    end
  end

  def report
    each_generation.with_index do |generation, depth|
      generation.each do |table_name, table_graph|
        print " " * depth
        puts [table_name, table_graph.try!(:to_s), depth].inspect
      end
    end
  end

  # Yields the following
  # 1. table name
  # 2. the foreign key columns used to filter this table, and a lambda that will return the foreign key ids
  def each_generation
    return enum_for(:each_generation) unless block_given?

    generations.each do |generation|
      yield generation
    end
  end

  protected
  def generations
    return @generations if @generations

    @generations = []
    table_graphs.each do |table_graph|
      q = []

      table_graph.each do |table_name, parent_table, configuration_for_table|
        q << [table_name, configuration_for_table || parent_table] if parent_table.nil?
      end

      until q.empty?
        @generations << q

        next_generation = []
        q.each do |table_name, _|
          table_graph.each do |child_table_name, parent_table, configuration_for_table|
            next_generation << [child_table_name, configuration_for_table || parent_table] if parent_table && parent_table.table_name == table_name
          end
        end

        q = next_generation
      end
    end

    @generations
  end
end
