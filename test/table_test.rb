require 'test_helper'

describe PartialKs::Table do
  describe "#model" do
    it "has a model" do
      table = PartialKs::Table.new("users")
      table.must_respond_to :model
    end
  end
end
