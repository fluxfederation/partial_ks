require 'test_helper'

def pks_tables(*args)
  args
end

def generator(manual, tables)
  PartialKs::ConfigurationGenerator.new(manual, tables).call.
    map {|f| [f.table_name, f.parent_model, f.custom_filter_relation] }
end

describe "generating dependencies" do
  let(:manual_configuration) do
    [
      ["users", nil, User.where(:id => [1])],
    ]
  end

  it "auto infers single belongs-to dependencies" do
    generator(manual_configuration, table_names: pks_tables("users", "blog_posts")).
      must_equal [
      ["users", nil, User.where(:id => [1])],
      ["blog_posts", User, nil]
    ]
  end

  it "auto infers top level tables" do
    generator(manual_configuration, table_names: pks_tables("users", "tags")).
      must_equal [
      ["users", nil, User.where(:id => [1])],
      ["tags", nil, nil]
    ]
  end
end
