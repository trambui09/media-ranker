require "test_helper"

describe Work do
  # it "does a thing" do
  #   value(1+1).must_equal 2
  # end
  describe "validations" do
    before do
      @work = Work.new(category: "book",
                       title: "test title",
                       creator: "test creator",
                       publication_year: 2020,
                       description: "test description"
      )
    end
    it "is valid when all fields are present" do
      expect(@work.valid?).must_equal true
    end

    it "is invalid w/o a title" do
      @work.title = nil

      expect(@work.valid?).must_equal false
      expect(@work.errors.messages.include?(:title)).must_equal true
      expect(@work.errors.messages[:title].include?("can't be blank")).must_equal true
    end

    it "is invalid if the title already exists" do
      # do we need the other fields?
      Work.create(title: @work.title,
                  category: @work.category,
                  creator: @work.creator,
                  publication_year: @work.publication_year,
                  description: @work.description
      )

      expect(@work.valid?).must_equal false
      expect(@work.errors.messages.include?(:title)).must_equal true
      expect(@work.errors.messages[:title].include?("has already been taken")).must_equal true

    end

  end

  describe "relations" do
    it "can have many votes" do

    end

    it "can have many users through votes" do

    end

  end

  describe "custom methods" do
    # TODO: not sure how I'd test for random?
    describe "spotlight" do
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
      end

      it "returns a random work" do
        # arrange
        sample_work = Work.spotlight
        # act
        # assert
        expect(sample_work).must_be_instance_of Work
        expect(sample_work.title).wont_be_nil
      end
    end

    describe "works_in_category" do

    end

    describe "top ten" do

    end

  end
end
