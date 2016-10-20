module PartialKs
  class Table
    attr_reader :table_name

    def initialize(table_name)
      @table_name = table_name
    end

    def model
      @model ||= table_name.classify.constantize
    rescue NameError
      nil
    end

    # sometimes the table is present, but the model is not defined
    # e.g. in market specific tables
    def model?
      model && model.respond_to?(:table_name)
    end

    def top_level_table?
      non_nullable_reflections.empty?
    end

    def non_nullable_parent_tables
      non_nullable_reflections.map(&:plural_name)
    end

    def parent_tables
      belongs_to_reflections.map(&:plural_name)
    end

    private
    def belongs_to_reflections
      @belongs_to_reflections ||= model.reflect_on_all_associations(:belongs_to)
    end

    def non_nullable_reflections
      # We have to consider the situation where the column does not exist on
      # the remote end, which results in a discrepancy between model.columns and the current schema
      belongs_to_reflections.reject do |reflection|
        fk_column = model.columns.find{|column| column.name.to_s == reflection.foreign_key.to_s }
        fk_column.nil? || fk_column.null
      end
    end
  end
end
