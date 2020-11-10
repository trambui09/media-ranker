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
      flash[:success] = "Successfully created #{@work.category} #{@work.id}"
      # might need to edit where we redriect to
      redirect_to work_path(@work)

    else
      # need a flash.now message
      # render :new
      # flash.now[:error] = "Something happened, #{@work.category} was not added :("
      render :new, status: :bad_request
    end


  end

  def edit
    @work = Work.find_by(id: params[:id])

    if @work.nil?
      head :not_found
      return
    end

  end

  def update
    @work = Work.find_by(id: params[:id])

    if @work.nil?
      head :not_found
      return
    elsif @work.update(work_params)
      # need a flash "Successfully updated book 675"
      flash[:success] = "Succesfully updated #{@work.category} #{@work.id}"
      redirect_to work_path(@work)
      return
    else # save failed
      render :edit, status: :bad_request
      return
    end

  end

  def destroy
    @work = Work.find_by(id: params[:id])

    if @work.nil?
      head :not_found
      return
    else
      @work.destroy
      # flash needed "Successfully destroyed album 736"
      flash[:success] = "Successfully destroyed #{@work.category} #{@work.id}"
      # TODO: redirect to the root_path
      redirect_to works_path
    end

  end

  private

  def work_params
    return params.require(:work).permit(:category, :title, :creator, :publication_year, :description)
  end
end
