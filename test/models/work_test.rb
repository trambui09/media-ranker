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

  end
end
