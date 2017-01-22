require 'test_helper'

describe "kitchen sync filter" do
  let(:table) { PartialKs::Table.new(PostTag) }

  it "uses parent as the filter" do
    parent = Tag
    filtered_table = PartialKs::FilteredTable.new(table, parent)
    filtered_table.kitchen_sync_filter.must_equal({"only" => 'tag_id IN (0)'})
  end

  it "uses the custom filter if provided" do
    filter = PostTag.where(:id => [1, 2])
    filtered_table = PartialKs::FilteredTable.new(table, nil, custom_filter_relation: filter)
    filtered_table.kitchen_sync_filter.must_equal({"only" => ' "post_tags"."id" IN (1, 2)'})
  end

  it "returns nil if parent is nil" do
    filtered_table = PartialKs::FilteredTable.new(table, nil)
    filtered_table.kitchen_sync_filter.must_be_nil
  end

  describe "via has_many association" do
    let(:post_tag_id) { 111 }

    it "can filter" do
      table = PartialKs::Table.new(BlogPost)
      filtered_table = PartialKs::FilteredTable.new(table, PostTag)
      PostTag.stub :pluck, [post_tag_id] do    # TODO verify the pluck
        filtered_table.kitchen_sync_filter.must_equal({"only" => "id IN (0,#{post_tag_id})"})
      end
    end
  end

  describe "table with different :foreign_key" do
    let(:table) { PartialKs::Table.new(OldTag) }

    it "uses the foreign key that's present in the table" do
      filtered_table = PartialKs::FilteredTable.new(table, OldEntry)
      filtered_table.kitchen_sync_filter.must_equal({"only" => 'blog_post_id IN (0)'})
    end
  end
end
