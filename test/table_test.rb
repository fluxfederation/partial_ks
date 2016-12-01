require 'test_helper'

describe PartialKs::Table do
  describe "#model" do
    it "has a model" do
      table = PartialKs::Table.new(User)
      table.must_respond_to :model
    end
  end

  describe "candidate parents" do
    it "returns nothing for a top level table" do
      table = PartialKs::Table.new(User)

      table.candidate_parent_classes.must_equal []
    end
  end
end
