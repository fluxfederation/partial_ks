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
end
