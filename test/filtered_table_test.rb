require 'test_helper'

describe "kitchen sync filter" do
  let(:table) { PartialKs::Table.new(PostTag) }
  let(:parent) { Minitest::Mock.new }

  it "proxies to Table if there's parent only" do
    table_parent_relation_method = :relation_for_associated_model
    relation_mock = Minitest::Mock.new
    relation_mock.expect :where_sql, "WHERE tag_id IN (0)"

    filtered_table = PartialKs::FilteredTable.new(table, parent)
    table.stub table_parent_relation_method, relation_mock do
      filtered_table.kitchen_sync_filter.must_equal({"only" => ' tag_id IN (0)'})
    end
  end

  it "uses the custom filter if provided" do
    filter = PostTag.where(:id => [1, 2])
    filtered_table = PartialKs::FilteredTable.new(table, nil, custom_filter_relation: filter)
    filtered_table.kitchen_sync_filter.must_equal({"only" => ' "post_tags"."id" IN (1, 2)'})
  end

  it "uses a string as a filter if provided" do
    string_filter = "1=0"
    filtered_table = PartialKs::FilteredTable.new(table, nil, custom_filter_relation: string_filter)
    filtered_table.kitchen_sync_filter.must_equal({"only" => string_filter})
  end

  it "returns nil if parent is nil" do
    filtered_table = PartialKs::FilteredTable.new(table, nil)
    filtered_table.kitchen_sync_filter.must_be_nil
  end

end
