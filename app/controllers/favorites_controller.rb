class FavoritesController < ApplicationController
  before_action :authenticate_user!

  def index
    @favorites = current_user.favorites
  end

  def create
    @favorite = current_user.favorites.create(cafe_id: params[:cafe_id])
    redirect_back(fallback_location: root_path)
  end

  def destroy
    @cafe = Cafe.find(params[:cafe_id])
    @favorite = current_user.favorites.find_by(cafe_id: @cafe.id)
    @favorite.destroy
    redirect_back(fallback_location: root_path)
  end
end
