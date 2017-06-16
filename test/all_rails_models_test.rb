require 'test_helper'

describe "all rails tables" do
  it "includes models that descend from ApplicationRecord" do
    PartialKs.all_rails_models.must_include User
  end

  it "excludes abstract classes like ApplicationRecord" do
    PartialKs.all_rails_models.wont_include ApplicationRecord
  end

  it "excludes subclass" do
    PartialKs.all_rails_models.wont_include SubTag
  end

  it "returns the same number of models as the number of tables" do
    PartialKs.all_rails_models.map(&:table_name).sort.must_equal ActiveRecord::Base.connection.tables.sort
  end

  it "does not choke on a table which has had its migration run" do
    PartialKs.all_rails_models.wont_include NewModel
  end

  it "can return models with different table_name" do
    model = OldEntry
    model.table_name.wont_equal model.name.tableize

    PartialKs.all_rails_models.must_include model
  end
end
