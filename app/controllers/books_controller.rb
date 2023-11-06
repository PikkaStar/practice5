class BooksController < ApplicationController
before_action :authenticate_user!
before_action :match_user,only: [:edit,:update]
  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      flash[:notice] = "successfully"
    redirect_to book_path(@book.id)
  else
    @user = current_user
    @books = Book.all
    render :index
    @book = Book.new
  end
  end

  def index
    @user = current_user
    @book = Book.new
    if params[:latest]
   @books = Book.latest
 elsif params[:old]
   @books = Book.old
 elsif params[:favorite_count]
   @books = Book.favorite_count
   elsif params[:comment_count]
   @books = Book.comment_count
 else
   @books = Book.all
 end
  end

  def show
    @book = Book.find(params[:id])
    @book_new = Book.new
    @user = @book.user
    @comment = BookComment.new
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      flash[:notice] = "successfully"
    redirect_to book_path(@book)
  else
    render :edit
  end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title,:body)
  end


  def match_user
    book = Book.find(params[:id])
    unless book.user_id == current_user.id
      redirect_to user_path(current_user)
    end
  end

end
