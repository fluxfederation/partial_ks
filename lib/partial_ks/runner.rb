class PartialKs::Runner
  attr_reader :table_graphs

  def initialize(table_graphs)
    @table_graphs = table_graphs
  end

  def run!
    each_generation do |generation|
      tables_to_filter = {}
      table_names = []

      generation.each do |table|
        table_names << table.table_name
        filter_config = table.filter_condition

        if !filter_config.nil?
          if filter_config.is_a?(ActiveRecord::Relation) || filter_config.respond_to?(:where_sql)
            only_filter = filter_config.where_sql.to_s.sub("WHERE", "")
          elsif filter_config.is_a?(String)
            only_filter = filter_config
          else
            # this only supports parents where it's a belongs_to
            # TODO we can make it work with has_many
            # e.g. SomeModel.reflect_on_association(:elses)
            only_filter = "#{filter_config.to_s.foreign_key} IN (#{[0, *filter_config.pluck(:id)].join(',')})"
          end

          tables_to_filter[table.table_name] = {"only" => only_filter}
        end
      end

      # TODO output only tables_to_filter, depending on how KS handles filters
      yield tables_to_filter, table_names
    end
  end

  def report
    result = []
    each_generation.with_index do |generation, depth|
      generation.each do |table|
        result << [table.table_name, table.parent_model, table.filter_condition, depth]
      end
    end
    result
  end

  def each_generation
    return enum_for(:each_generation) unless block_given?

    generations.each do |generation|
      yield generation
    end
  end

  protected
  def generations
    return @generations if defined?(@generations)

    @generations = []
    table_graphs.each do |table_graph|
      q = []

      table_graph.each do |table|
        q << table if table.parent_model.nil?
      end

      until q.empty?
        @generations << q

        next_generation = []
        q.each do |table|
          table_graph.each do |child_table|
            next_generation << child_table if child_table.parent_model && child_table.parent_model.table_name == table.table_name
          end
        end

        q = next_generation
      end
    end

    @generations
  end
end
