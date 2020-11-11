require "test_helper"

describe Vote do
  # it "does a thing" do
  #   value(1+1).must_equal 2
  # end
  describe "validations" do

  end
  describe "relations" do
    # it "has a work" do
    #
    #   vote = votes(:first)
    #
    #   expect(vote.work_id).must_equal works(:cowboy).id
    #
    # end

    it "can set the work" do
      vote = Vote.new
      vote.work = works(:cowboy)
      expect(vote.work_id).must_equal works(:cowboy).id

    end

    # TODO: check if I need the "has a work/user" tests
    it "has a user" do

    end

    it "can set the user" do
      vote = Vote.new
      vote.user = users(:miso)
      expect(vote.user_id).must_equal users(:miso).id

    end
  end
end
