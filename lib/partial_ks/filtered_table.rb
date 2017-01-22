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
      if custom_filter_relation
        {"only" => filter_based_on_custom_filter_relation}
      elsif parent_model
        {"only" => filter_based_on_parent_model}
      else
        nil
      end
    end

    protected
    def filter_based_on_parent_model
      # TODO abstract this away into PartialKs::Table
      association = table.model.reflect_on_all_associations.find {|assoc| assoc.class_name == parent_model.name}
      raise "#{filter_condition.name} not found in #{table.model.name} associations" if association.nil?

      case association.macro
      when :belongs_to
        "#{association.foreign_key} IN (#{[0, *parent_model.pluck(:id)].join(',')})"
      when :has_many
        "#{table.model.primary_key} IN (#{[0, *parent_model.pluck(association.foreign_key)].join(',')})"
      else
        raise "Unknown macro"
      end
    end

    def filter_based_on_custom_filter_relation
      if custom_filter_relation.is_a?(ActiveRecord::Relation) || custom_filter_relation.respond_to?(:where_sql)
        only_filter = custom_filter_relation.where_sql.to_s.sub("WHERE", "")
      elsif custom_filter_relation.is_a?(String)
        only_filter = custom_filter_relation
      end
    end

  end
end
