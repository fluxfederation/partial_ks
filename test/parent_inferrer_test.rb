require 'test_helper'

describe "inferring parents" do
  it "infers no parent for a top level table" do
    table = PartialKs::Table.new(Tag)
    table.inferred_parent_class.must_be_nil
  end

  it "infers a parent for a table that has a single belongs_to" do
    table = PartialKs::Table.new(BlogPost)
    table.inferred_parent_class.must_equal User
  end

  it "infers a multi-parent for a table has multiple belongs_to" do
    table = PartialKs::Table.new(PostTag)
    table.inferred_parent_class.must_equal PartialKs::MultiParent.new([BlogPost, Tag])
  end
end
