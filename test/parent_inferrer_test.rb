require 'test_helper'

describe "inferring parents" do
  it "infers no parent for a top level table" do
    table = PartialKs::Table.new(Tag)
    PartialKs::ParentInferrer.new(table).inferred_parent_class.must_be_nil
  end

  it "infers a parent for a table that has a single belongs_to" do
    table = PartialKs::Table.new(BlogPost)
    PartialKs::ParentInferrer.new(table).inferred_parent_class.must_equal User
  end

  it "infers no parent for a table has multiple belongs_to" do
    table = PartialKs::Table.new(PostTag)
    lambda { PartialKs::ParentInferrer.new(table).inferred_parent_class }.must_raise PartialKs::ParentInferrer::CannotInfer
  end
end
