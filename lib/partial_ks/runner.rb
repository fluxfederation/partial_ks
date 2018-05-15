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
          filter_config = table.to_sql

          if !filter_config.nil?
            tables_to_filter[table.table_name] = filter_config
          end
        end

        yield tables_to_filter, table_names
      end
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
      q = []

      models_list.each do |model, parent, filter|
        q << PartialKs::FilteredTable.new(model, nil, custom_filter_relation: filter) if parent.nil?
      end

      until q.empty?
        @generations << q

        next_generation = []
        q.each do |table|
          models_list.each do |child_model, parent, filter|
            # I have access to parent here - link model to child_model
            next_generation << PartialKs::FilteredTable.new(child_model, table, custom_filter_relation: filter) if parent && parent.table_name == table.table_name
          end
        end

        q = next_generation
      end

      @generations
    end
  end
end
