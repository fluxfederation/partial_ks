require 'test_helper'

describe "filtered table" do
  let(:model) { PostTag }
  let(:parent_model) { BlogPost }

  it "proxies to Table if there's parent only" do
    table_parent_relation_method = :relation_for_associated_model
    relation_mock = Minitest::Mock.new
    statement = "SELECT * FROM #{model.table_name} WHERE tag_id IN (0)"
    relation_mock.expect :to_sql, statement
    relation_mock.expect :to_sql, statement
    parent = PartialKs::FilteredTable.new(parent, nil, custom_filter_relation: BlogPost.where("1=0"))

    filtered_table = PartialKs::FilteredTable.new(model, parent)
    filtered_table.table.stub table_parent_relation_method, relation_mock do
      filtered_table.to_sql.must_equal(statement)
    end
  end

  it "short-circuits evaluation if the parent has no filter" do
    parent = PartialKs::FilteredTable.new(parent, nil)
    filtered_table = PartialKs::FilteredTable.new(model, parent)
    filtered_table.to_sql.must_be_nil
  end

  it "uses the custom filter if provided" do
    filter = PostTag.where(:id => [1, 2])
    filtered_table = PartialKs::FilteredTable.new(model, nil, custom_filter_relation: filter)
    filtered_table.to_sql.must_equal('SELECT "post_tags".* FROM "post_tags" WHERE "post_tags"."id" IN (1, 2)')
  end

  it "uses the filter inside a lambda" do
    filter = -> { PostTag.where(:id => [1, 2]) }
    filtered_table = PartialKs::FilteredTable.new(model, nil, custom_filter_relation: filter)
    filtered_table.to_sql.must_equal('SELECT "post_tags".* FROM "post_tags" WHERE "post_tags"."id" IN (1, 2)')
  end

  it "uses a SQL where fragment as a filter if provided" do
    string_filter = "1=0"
    filtered_table = PartialKs::FilteredTable.new(model, nil, custom_filter_relation: string_filter)
    filtered_table.to_sql.must_equal(string_filter)
  end

  it "uses a SQL statement as a filter if provided" do
    string_filter = "1=0"
    sql_statement = "select * from #{model.table_name} where #{string_filter}"
    filtered_table = PartialKs::FilteredTable.new(model, nil, custom_filter_relation: sql_statement)
    filtered_table.to_sql.must_equal(sql_statement)
  end

  it "returns nil if parent is nil" do
    filtered_table = PartialKs::FilteredTable.new(model, nil)
    filtered_table.to_sql.must_be_nil
  end

  it "generates a complete where fragment from a custom filter" do
    filter = PostTag.where(:id => 2)
    filtered_table = PartialKs::FilteredTable.new(model, nil, custom_filter_relation: filter)
    filtered_table.to_sql.must_equal('SELECT "post_tags".* FROM "post_tags" WHERE "post_tags"."id" = 2')
  end
end
