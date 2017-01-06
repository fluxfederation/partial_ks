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

    def tree
      root = PartialKs::Tree.new(nil)

      table_graphs.each do |filtered_tables|
        index = filtered_tables.group_by {|table| table.parent_model.try(:table_name) }

        index[nil].each do |table|
          root.add(table)
        end

        root.children.each do |child|
          add_nodes(index, child)
        end
      end

      root
    end

    protected
    def filtered_tables
      @filtered_tables ||= models_list.map {|model, parent, custom_filter| PartialKs::FilteredTable.new(model, parent, custom_filter_relation: custom_filter)}
    end

    def add_nodes(index, current_node)
      child_items = index[current_node.item.table_name]
      puts current_node.item.table_name
      puts child_items.size.to_s if child_items
      puts "0" unless child_items
      return unless child_items

      child_items.each do |item|
        current_node.add(item)
      end

      current_node.children.each do |child_node|
        add_nodes(index, child_node)
      end
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
