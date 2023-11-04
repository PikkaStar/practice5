class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :match_user,only: [:edit,:update]
  def index
    @user = current_user
    @book = Book.new
    @users = User.all
  end

  def show
    @book = Book.new
    @user = User.find(params[:id])
    @books = @user.books
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:notice] = "successfully"
    redirect_to user_path(@user)
  else
    render :edit
  end
  end

  def favorite
    @user = User.find(params[:id])
    favorites = Favorite.where(user_id: @user.id).pluck(:book_id)
    @favorite_books = Book.find(favorites)
  end

  private
  def user_params
    params.require(:user).permit(:name,:introduction,:profile_image)
  end

  def match_user
    user = User.find(params[:id])
    unless user.id == current_user.id
      redirect_to user_path(current_user)
    end
  end

end
