class PartialKs::ParentInferrer
  CannotInfer = Class.new(StandardError)

  attr_reader :table

  def initialize(table)
    @table = table
  end

  def inferred_parent_table
    if table.top_level_table?
      nil
    elsif table.non_nullable_parent_tables.size == 1
      table.non_nullable_parent_tables.first
    else
      raise CannotInfer, "table has multiple candidates for parents"
    end
  end
end
