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
end
