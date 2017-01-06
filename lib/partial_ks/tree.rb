module PartialKs
  class Tree
    attr_reader :children, :item

    def initialize(item)
      @item = item
      @children = []
    end

    def add(child_item)
      children << PartialKs::Tree.new(child_item)
    end

    def search(search_item, &criteria)
      if criteria
        return self if criteria.call(item, search_item)
      else
        return self if search_item == item
      end

      children.each do |child|
        if block_given?
          result = child.search(search_item, &criteria)
        else
          result = child.search(search_item)
        end
        return result if result
      end

      nil
    end
  end
end
