require 'test_helper'

describe "inferring parents" do
  it "infers no parent for a top level table" do
    table = PartialKs::Table.new("tags")
    PartialKs::ParentInferrer.new(table).inferred_parent_table.must_equal nil
  end

  it "infers a parent for a table that has a single belongs_to" do
    table = PartialKs::Table.new("blog_posts")
    PartialKs::ParentInferrer.new(table).inferred_parent_table.must_equal "users"
  end

  it "infers no parent for a table has multiple belongs_to" do
    table = PartialKs::Table.new("post_tags")
    lambda { PartialKs::ParentInferrer.new(table).inferred_parent_table }.must_raise PartialKs::ParentInferrer::CannotInfer
  end
end
