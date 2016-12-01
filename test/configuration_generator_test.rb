require 'test_helper'

def generator(manual, tables)
  PartialKs::ConfigurationGenerator.new(manual, tables).call.
    map {|f| [f.table_name, f.parent_model, f.custom_filter_relation] }
end

describe "generating dependencies" do
  let(:manual_configuration) do
    [
      [User, nil, User.where(:id => [1])],
    ]
  end

  it "auto infers single belongs-to dependencies" do
    generator(manual_configuration, models: [User, BlogPost]).
      must_equal [
      ["users", nil, User.where(:id => [1])],
      ["blog_posts", User, nil]
    ]
  end

  it "auto infers top level tables" do
    generator(manual_configuration, models: [User, Tag]).
      must_equal [
      ["users", nil, User.where(:id => [1])],
      ["tags", nil, nil]
    ]
  end

  it "can infer models with different table_name" do
    model = OldEntry
    model.table_name.wont_equal model.name.tableize

    generator(manual_configuration, models: [User, model]).
      must_equal [
      ["users", nil, User.where(:id => [1])],
      ["cms_table", nil, nil]
    ]
  end
end
