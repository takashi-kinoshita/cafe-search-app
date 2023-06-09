class CafesController < ApplicationController
  def index
    @cafes = Cafe.order(:name).paginate(page: params[:page], per_page: 10)
  end

  def new
    @cafe = Cafe.new
  end

  def create
    @cafe = Cafe.new(cafe_params)
    if @cafe.save
      redirect_to @cafe
    else
      render "new"
    end
  end

  def show
    @cafe = Cafe.find(params[:id])
  end

  def edit
    @cafe = Cafe.find(params[:id])
  end

  def update
    @cafe = Cafe.find(params[:id])
    if @cafe.update(cafe_params)
      redirect_to @cafe
    else
      render "edit"
    end
  end

  def destroy
    @cafe = Cafe.find(params[:id])
    @cafe.destroy
    redirect_to cafes_path
  end

  private

  def cafe_params
    params.require(:cafe).permit(:name, :address, :latitude, :longitude, :phone, :opening, :closed, :images)
  end
end
