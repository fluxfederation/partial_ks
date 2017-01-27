require 'test_helper'

describe PartialKs::Table do
  describe "#model" do
    it "has a model" do
      table = PartialKs::Table.new(User)
      table.must_respond_to :model
    end
  end

  describe "candidate parents" do
    it "returns nothing for a top level table" do
      table = PartialKs::Table.new(User)

      table.candidate_parent_classes.must_equal []
    end
  end

  describe "relation for association" do
    let(:table) { PartialKs::Table.new(BlogPost) }

    it "emits the correct foreign key for the table for belongs_to" do
      table.relation_for_associated_model(User).must_equal BlogPost.where(:user_id => 0)
    end

    it "use results from pluck for belongs_to" do
      user_ids = [1,2,3]
      User.stub :pluck, user_ids do
        table.relation_for_associated_model(User).must_equal BlogPost.where(:user_id => [0] + user_ids)
      end
    end

    it "emits the id condition for has_many" do
      table.relation_for_associated_model(PostTag).must_equal BlogPost.where(:id => 0)
    end

    it "uses results from pluck for has_many" do
      id = 111

      PostTag.stub :pluck, [id] do
        table.relation_for_associated_model(PostTag).must_equal BlogPost.where(:id => [0] + [id])
      end
    end

    describe "table with non-conventional :foreign_key" do
      let(:table) { PartialKs::Table.new(OldTag) }

      it "uses the foreign key that's present in the table" do
        table.relation_for_associated_model(OldEntry).must_equal OldTag.where(:blog_post_id => 0)
      end
    end
  end
end
