class PartialKs::ParentInferrer
  CannotInfer = Class.new(StandardError)

  attr_reader :table

  def initialize(table)
    @table = table
  end

  def inferred_parent_class
    if table.top_level_table?
      nil
    elsif table.candidate_parent_classes.size == 1
      table.candidate_parent_classes.first
    else
      raise CannotInfer, "table has multiple candidates for parents"
    end
  end
end
