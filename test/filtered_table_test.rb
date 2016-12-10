require 'test_helper'

describe "filter condition" do
  let(:table) { PartialKs::Table.new(User) }

  it "uses parent as the filter" do
    parent = Tag
    filtered_table = PartialKs::FilteredTable.new(table, parent)
    filtered_table.filter_condition.must_equal parent
  end

  it "uses the custom filter if provided" do
    filter = User.where(:id => 1)
    filtered_table = PartialKs::FilteredTable.new(table, nil, custom_filter_relation: filter)
    filtered_table.filter_condition.must_equal filter
  end

  it "returns nil if parent is nil" do
    filtered_table = PartialKs::FilteredTable.new(table, nil)
    filtered_table.filter_condition.must_be_nil
  end
end

describe "kitchen sync filter" do
  let(:table) { PartialKs::Table.new(User) }

  it "uses parent as the filter" do
    parent = Tag
    filtered_table = PartialKs::FilteredTable.new(table, parent)
    filtered_table.kitchen_sync_filter.must_equal({"only" => 'tag_id IN (0)'})
  end

  it "uses the custom filter if provided" do
    filter = User.where(:id => [1, 2])
    filtered_table = PartialKs::FilteredTable.new(table, nil, custom_filter_relation: filter)
    filtered_table.kitchen_sync_filter.must_equal({"only" => ' "users"."id" IN (1, 2)'})
  end

  it "returns nil if parent is nil" do
    filtered_table = PartialKs::FilteredTable.new(table, nil)
    filtered_table.kitchen_sync_filter.must_be_nil
  end
end
