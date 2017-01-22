module PartialKs
  class FilteredTable
    attr_reader :table, :parent_model, :custom_filter_relation
    delegate :table_name, :to => :table

    def initialize(table, parent_model, custom_filter_relation: nil)
      @table = table
      @parent_model = parent_model
      @custom_filter_relation = custom_filter_relation
    end

    def kitchen_sync_filter
      filter_condition = custom_filter_relation || parent_model

      if !filter_condition.nil?
        if filter_condition.is_a?(ActiveRecord::Relation) || filter_condition.respond_to?(:where_sql)
          only_filter = filter_condition.where_sql.to_s.sub("WHERE", "")
        elsif filter_condition.is_a?(String)
          only_filter = filter_condition
        else
          # TODO abstract this away into PartialKs::Table
          association = table.model.reflect_on_all_associations.find {|assoc| assoc.class_name == filter_condition.name}
          raise "#{filter_condition.name} not found in #{table.model.name} associations" if association.nil?

          only_filter = case association.macro
            when :belongs_to
              "#{association.foreign_key} IN (#{[0, *filter_condition.pluck(:id)].join(',')})"
            when :has_many
              "#{table.model.primary_key} IN (#{[0, *filter_condition.pluck(association.foreign_key)].join(',')})"
            else
              raise "Unknown macro"
            end
        end

        {"only" => only_filter}
      end
    end
  end
end
