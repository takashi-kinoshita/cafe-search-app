class ReviewsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_cafe, only: [:create]
  before_action :set_review, only: [:edit, :update, :destroy]

  def create
    @review = @cafe.reviews.build(review_params)
    @review.user_id = current_user.id
    if @review.save
      redirect_to @cafe
    else
      flash.now[:error] = "Review could not be saved."
      render :new
    end
  end

  def edit
  end

  def update
    if @review.update(review_params)
      redirect_to @review.cafe
    else
      flash.now[:error] = "Review could not be updated."
      render :edit
    end
  end

  def destroy
    @review.destroy
    redirect_to @review.cafe
  end

  private

  def set_cafe
    @cafe = Cafe.find(params[:cafe_id])
  end

  def set_review
    @review = Review.find(params[:id])
  end

  def review_params
    params.require(:review).permit(:content)
  end
end
