class WorksController < ApplicationController

  def index
    @works = Work.all.order(:category)
    @album_works = Work.where(category: 'album')
    @book_works = Work.where(category: 'book')
  end

  def show
    @work = Work.find_by(id: params[:id])

    if @work.nil?
      head :not_found
      return
    end
  end

  def new
    @work = Work.new
  end

  def create
    @work = Work.new(work_params)

    if @work.save
      # need a flash message
      # redirect to the work show page

    else
      # need a flash.now message
      # render :new 


    end


  end

  def edit

  end

  def update

  end

  def destroy

  end

  private

  def work_params
    return params.require(:work).permit(:category, :title, :creator, :publication_year, :description)
  end
end
