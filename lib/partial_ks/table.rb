module PartialKs
  class Table
    attr_reader :model
    delegate :table_name, :to => :model

    def initialize(model)
      @model = model
    end

    # sometimes the table is present, but the model is not defined
    # e.g. in market specific tables
    def model?
      model && model.respond_to?(:table_name)
    end

    def top_level_table?
      candidate_parent_classes.empty?
    end

    # NB: can't do polymorphic for now, rails errors on reflection#klass
    # see, e.g. https://github.com/rails/rails/issues/15833
    def candidate_parent_classes
      non_nullable_reflections.reject(&:polymorphic?).map(&:klass)
    end

    def parent_tables
      belongs_to_reflections.map(&:table_name)
    end

    def relation_for_associated_model(klass)
      association = model.reflect_on_all_associations.find {|assoc| assoc.class_name == klass.name}
      raise "#{filter_condition.name} not found in #{model.name} associations" if association.nil?

      case association.macro
      when :belongs_to
        model.where(association.foreign_key => [0, *klass.pluck(:id)])
      when :has_many
        model.where(model.primary_key => [0, *klass.pluck(association.foreign_key)])
      else
        raise "Unknown macro"
      end
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
