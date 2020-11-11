require "test_helper"

describe User do
  # it "does a thing" do
  #   value(1+1).must_equal 2
  # end
  let (:new_user) {
    User.new(username: "Testing username")
  }

  describe "relations" do
    before do
      new_user.save
      # second_user = users(:tram)

      @new_work = works(:cowboy)
      @second_work = works(:undocumented)

      vote_1 = Vote.create(user_id: new_user.id, work_id: @new_work.id)
      vote_2 = Vote.create(user_id: new_user.id, work_id: @second_work.id)
    end
    it "can have many votes" do

      expect(new_user.votes.count).must_equal 2

      new_user.votes.each do |vote|
        expect(vote).must_be_instance_of Vote
      end

      expect(new_user.votes.last.work_id).must_equal @second_work.id

    end

    it "can have many works through votes" do

      expect(new_user.works.count).must_equal 2

      new_user.works.each do |work|
        expect(work).must_be_instance_of Work
      end

      expect(new_user.works.first.title).must_equal @new_work.title

    end

  end

end
