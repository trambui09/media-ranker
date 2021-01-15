require "test_helper"

describe WorksController do
  # it "does a thing" do
  #   value(1+1).must_equal 2
  # end
  before do
    @work = works(:cowboy)
  end
  describe "index" do
    it "can get the index path" do

      get works_path
      must_respond_with :success
    end

    #TODO: add another test when there's no works present by destroying the works
  end

  describe "show" do
    it "can get to the work show page" do

      get work_path(@work.id)

      must_respond_with :success
    end
    it " will show not_found if the work id isn't found" do
      get work_path(-1)

      must_respond_with :not_found
    end
  end

  describe "new" do
    it "can get to the new work page" do

      get new_work_path
      must_respond_with :success
    end
  end

  describe "create" do
    before do
      @work_hash = {
          work: {
              title: "testing title",
              creator: "testing creator",
              category: "album",
              publication_year: 2002,
              description: "testing description"
          }
      }
    end

    it "can create a new work" do
      expect {
        post works_path, params: @work_hash
      }.must_differ "Work.count", 1

      expect(Work.last.title).must_equal @work_hash[:work][:title]

      must_redirect_to work_path(Work.last.id)
      must_respond_with :redirect

    end

    it "will not create new work with bad params" do
      @work_hash[:work][:title] = nil

      expect {
        post works_path, params: @work_hash
      }.wont_differ "Work.count"

      must_respond_with :bad_request

    end
  end

  describe "edit" do
    it "can get an edit page for an existing work" do
      get edit_work_path(@work.id)
      must_respond_with :success
    end

    it "will show not_found when trying to edit an invalid work" do
      get edit_work_path(-1)
      must_respond_with :not_found

    end
  end

  describe "update" do

    let (:new_work_hash) {
      {
          work: {
              title: "testing title",
              creator: "testing creator",
              category: "book",
              publication_year: 2005,
              description: "testing description"
          }
      }
    }

    it "can update an existing work" do
      # arrange
      expect {
        patch work_path(@work.id), params: new_work_hash
      }.wont_differ "Work.count"

      must_redirect_to work_path(@work.id)

      work = Work.find_by(id: @work.id )
      expect(work.title).must_equal new_work_hash[:work][:title]

    end

    it "would show not_found given an invalid work id" do
      expect {
        patch work_path(-1), params: new_work_hash
      }.wont_differ "Work.count"

      must_respond_with :not_found

    end

    it "will not update if the params is invalid (missing title)" do
      new_work_hash[:work][:title] = nil

      expect {
        patch work_path(@work.id), params: new_work_hash
      }.wont_differ "Work.count"

      # since it didn't update because there's no title
      # when we reload the page
      # there will still be a title
      @work.reload
      must_respond_with :bad_request
      expect(@work.title).wont_be_nil
    end

    describe "destroy" do
      it "can delete a work from the DB " do
        expect {
          delete work_path(@work.id)
        }.must_differ "Work.count", -1

        deleted_work = Work.find_by(id: @work.id)
        expect(deleted_work).must_be_nil

        must_redirect_to root_path


      end

      it "will show not_found for an invalid work" do
        expect {
          delete work_path(-1)
        }.wont_differ "Work.count"

        must_respond_with :not_found
      end
    end

  end


end
