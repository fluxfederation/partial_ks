require 'test_helper'

describe "tree search" do
  let(:item) { [:a, :b, :c] }
  let(:tree) { PartialKs::Tree.new(item) }

  it "searches on the current node" do
    tree.search(item).must_equal tree
  end

  it "can search by passing in a block" do
    tree.search([:a, :z, :z]).must_be_nil
    tree.search([:a, :z, :z]){ |item, search_item| item.first == search_item.first  }.must_equal tree
  end

  describe "with children" do
    before { tree.add([:x, :y, :z]) }
    let(:child) { tree.children.first }

    it "can search on children" do
      tree.search([:x, :y, :z]).must_equal child
    end

    it "can search by passing in a block" do
      tree.search([:x, :z, :z]).must_be_nil
      tree.search([:x, :z, :z]){ |item, search_item| item.first == search_item.first  }.must_equal child
    end

    it "finds nothing on a failed search" do
      tree.search([:nothing]).must_be_nil
    end
  end
end
