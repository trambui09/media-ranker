require "test_helper"

describe Work do
  # it "does a thing" do
  #   value(1+1).must_equal 2
  # end
  let (:new_work) {
    Work.new(title: "Testing title",
             creator: "Testing creator",
             category: "album",
             publication_year: 2020,
             description: "testing description")
    # TODO: check if works.yml would work here?
    # works(:undocumented)
  }

  it "responds to the fields" do
    new_work.save
    work = Work.first

    [:title, :category, :creator, :publication_year, :description].each do |field|
      expect(work).must_respond_to field
    end
  end
  describe "validations" do
    # before do
    #   @work = Work.new(category: "book",
    #                    title: "test title",
    #                    creator: "test creator",
    #                    publication_year: 2020,
    #                    description: "test description"
    #   )
    # end
    it "is valid when all fields are present" do
      new_work.save
      expect(new_work.valid?).must_equal true
    end

    it "is invalid w/o a title" do
      new_work.title = nil

      expect(new_work.valid?).must_equal false
      expect(new_work.errors.messages.include?(:title)).must_equal true
      expect(new_work.errors.messages[:title].include?("can't be blank")).must_equal true
    end

    it "is invalid if the title already exists" do
      # do we need the other fields? I'm going with no
      Work.create(title: new_work.title)

      expect(new_work.valid?).must_equal false
      expect(new_work.errors.messages).must_include :title
      expect(new_work.errors.messages[:title].include?("has already been taken")).must_equal true

    end

  end

  describe "relations" do
    before do
      new_work.save
      @new_user = users(:miso)
      @second_user = users(:tram)

      Vote.create(user_id: @new_user.id, work_id: new_work.id)
      Vote.create(user_id: @second_user.id, work_id: new_work.id)
    end
    it "can have many votes" do
      # Assert
      expect(new_work.votes.count).must_equal 2

      new_work.votes.each do |vote|
        expect(vote).must_be_instance_of Vote
      end

      expect(new_work.votes.first.user_id).must_equal @new_user.id

    end

    it "can have many users through votes" do

      expect(new_work.users.count).must_equal 2

      new_work.users.each do |user|
        expect(user).must_be_instance_of User
      end

      expect(new_work.users.first.username).must_equal @new_user.username

    end
  end

  describe "custom methods" do
    # TODO: not sure how I'd test for random?
    describe "spotlight" do
      # before do
      #   @work_1 = Work.create(category: "book",
      #               title: "test title",
      #               creator: "test creator",
      #               publication_year: 2020,
      #               description: "test description"
      #   )
      #
      #   @work_2 = Work.create(category: "book",
      #               title: "test title 2 ",
      #               creator: "test creator 2 ",
      #               publication_year: 2019,
      #               description: "test description 2"
      #   )
      # end

      it "returns the work with the highest vote" do
        expect(works(:cowboy).votes.count).must_equal works(:undocumented).votes.count
        # arrange
        # create! because we're making a Vote instance in the work test.
        Vote.create!(user: users(:miso), work: works(:cowboy))
        top_work = Work.spotlight
        highest_voted_work = works(:cowboy)
        # # act
        # # assert
        expect(top_work).must_be_instance_of Work
        expect(top_work).must_equal highest_voted_work

      end
    end

    # TODO: how can I test the top ten category?
    describe "top ten" do
      before do
        @work_1 = Work.create(category: "book",
                              title: "test title",
                              creator: "test creator",
                              publication_year: 2020,
                              description: "test description"
        )

        @work_2 = Work.create(category: "book",
                              title: "test title 2 ",
                              creator: "test creator 2 ",
                              publication_year: 2019,
                              description: "test description 2"
        )

        @work_3 = works(:cowboy)
        @work_4 = works(:undocumented)
      end
      it "returns the work in the right category" do

        # act
        book_top_ten = Work.top_ten("book")

        book_top_ten.each do |book|
          expect(book).must_be_instance_of Work
          expect(book.category).must_equal "book"
        end

      end

      # it "returns by highest votes desc " do
      #
      # end

    end

    describe "date_voted_on" do

      it "returns the the date of when the work was voted" do
        # Arrange
        new_work.save
        user = users(:miso)
        vote_1 = Vote.create(user_id: user.id, work_id: new_work.id )

        # act and assert
        expect(new_work.date_voted_on).must_equal vote_1.created_at.strftime('%b %d, %Y')

      end

    end
  end
end
