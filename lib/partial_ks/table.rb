module PartialKs
  class Table
    attr_reader :model
    delegate :table_name, :to => :model

    def initialize(model)
      @model = model
    end

    def inferred_parent_class
      if candidate_parent_classes.empty?
        nil
      elsif candidate_parent_classes.size == 1
        candidate_parent_classes.first
      else
        MultiParent.new(candidate_parent_classes)
      end
    end

    # NB: can't do polymorphic for now, rails errors on reflection#klass
    # see, e.g. https://github.com/rails/rails/issues/15833
    def candidate_parent_classes
      non_nullable_reflections.reject(&:polymorphic?).map(&:klass)
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

  # TODO confirm this is what we want
  class MultiParent
    attr_reader :parents

    def initialize(parents)
      @parents = parents
    end

    def ==(other)
      table_name == other.table_name if other
    end

    # only used in comparison in Runner
    def table_name
      parents.map(&:table_name).join(",")
    end
  end
end
