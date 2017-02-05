module PartialKs
  class Runner
    attr_reader :models_list

    def initialize(models_list)
      @models_list = models_list
    end

    def run!
      each_generation do |generation|
        tables_to_filter = {}
        table_names = []

        generation.each do |table|
          table_names << table.table_name
          filter_config = table.kitchen_sync_filter

          if !filter_config.nil?
            tables_to_filter[table.table_name] = filter_config
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
          result << [table.table_name, table.parent_model, table.custom_filter_relation, depth]
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
    def filtered_tables
      @filtered_tables ||= models_list.map {|model, parent, custom_filter| PartialKs::FilteredTable.new(model, parent, custom_filter_relation: custom_filter)}
    end

    def generations
      return @generations if defined?(@generations)

      @generations = []
      q = []

      filtered_tables.each do |filtered_table|
        q << filtered_table if filtered_table.parent_model.nil?
      end

      until q.empty?
        @generations << q

        next_generation = []
        q.each do |table|
          filtered_tables.each do |child_table|
            next_generation << child_table if child_table.parent_model && child_table.parent_model.table_name == table.table_name
          end
        end

        q = next_generation
      end

      @generations
    end
  end
end
