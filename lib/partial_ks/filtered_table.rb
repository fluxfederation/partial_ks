class PartialKs::FilteredTable
  attr_reader :table, :parent_model, :custom_filter_relation
  delegate :table_name, :to => :table

  def initialize(table, parent_model, custom_filter_relation: nil)
    @table = table
    @parent_model = parent_model
    @custom_filter_relation = custom_filter_relation
  end

  def filter_condition
    custom_filter_relation || parent_model
  end

  def kitchen_sync_filter
    if !filter_condition.nil?
      if filter_condition.is_a?(ActiveRecord::Relation) || filter_condition.respond_to?(:where_sql)
        only_filter = filter_condition.where_sql.to_s.sub("WHERE", "")
      elsif filter_condition.is_a?(String)
        only_filter = filter_condition
      else
        # this only supports parents where it's a belongs_to
        # TODO we can make it work with has_many
        # e.g. SomeModel.reflect_on_association(:elses)
        only_filter = "#{filter_condition.to_s.foreign_key} IN (#{[0, *filter_condition.pluck(:id)].join(',')})"
      end

      {"only" => only_filter}
    end
  end
end
