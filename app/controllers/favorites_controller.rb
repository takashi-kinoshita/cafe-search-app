class FavoritesController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token, only: [:create_via_api]

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

  def create_via_api
    cafe_id = params[:cafeId]
    cafe_name = params[:name]
    cafe_address = params[:address]

    cafe = Cafe.find_or_create_by(id: cafe_id, name: cafe_name, address: cafe_address)

    favorite = current_user.favorites.create(cafe: cafe)

    if favorite.persisted?
      render json: { status: 'success' }, status: 200
    else
      render json: { status: 'error' }, status: 500
    end
  end
end
