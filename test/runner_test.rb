require 'test_helper'

describe 'end to end testing' do
  it "runs without error" do
    generator_output = PartialKs::ConfigurationGenerator.new([]).call
    PartialKs::Runner.new([generator_output]).run! do |tables_to_filter, table_names|
      # left empty
    end
  end
end

describe 'running based on output from generator' do
  let(:manual_configuration) do
    [
      ["users", nil, User.where(:id => [1])],
    ]
  end

  let(:generator_output) do
    [
      PartialKs::FilteredTable.new(PartialKs::Table.new(User), nil, custom_filter_relation: User.where(:id => [1])),
      PartialKs::FilteredTable.new(PartialKs::Table.new(Tag), nil),
      PartialKs::FilteredTable.new(PartialKs::Table.new(BlogPost), User),
    ]
  end

  let(:runner) { PartialKs::Runner.new([generator_output]) }

  it "reports everything" do
    runner.report.must_equal [
      ["users", nil, User.where(:id => [1]), 0],
      ["tags", nil, nil, 0],
      ["blog_posts", User, nil, 1],
    ]
  end

  it "yields all table names" do
    expected_table_names = [User, Tag, BlogPost].map(&:table_name)
    actual_table_names   = []
    runner.run! do |tables_to_filter, table_names|
      actual_table_names += table_names
    end

    actual_table_names.must_equal expected_table_names
  end

  it "yields all non-null filters" do
    expected_filters     = [User, BlogPost].map(&:table_name)
    actual_filters       = {}

    runner.run! do |tables_to_filter, table_names|
      actual_filters.merge!(tables_to_filter)
    end

    actual_filters.size.must_equal expected_filters.size
    actual_filters.keys.must_equal expected_filters
    expected_filters.each do |table_name|
      actual_filters[table_name]["only"].must_be_kind_of String
    end
  end
end
