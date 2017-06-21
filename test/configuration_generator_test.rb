require 'test_helper'

describe "generating dependencies" do
  let(:manual_configuration) do
    [
      [User, nil, User.where(:id => [1])],
    ]
  end

  it "returns the manual_configuration" do
    result = PartialKs::ModelsList.new(manual_configuration).all
    result.must_include manual_configuration.first
  end

  it "processes all models" do
    result = PartialKs::ModelsList.new(manual_configuration).all
    result.size.must_equal PartialKs.all_rails_models.size
  end

  it "can identify MultiParent as issues" do
    PartialKs::ModelsList.new(manual_configuration).issues.map(&:last).map(&:class).must_equal [PartialKs::MultiParent]
  end
end
