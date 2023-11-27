class BooksController < ApplicationController
  before_action :authenticate_user!
  before_action :match_user, only: [:edit, :update]
  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    tag_list = params[:book][:name].split(",")
    if @book.save
      @book.save_tags(tag_list)
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
    @tag_list = Tag.all
  end

  def show
    @book = Book.find(params[:id])
    @tag_list = @book.tags.pluck(:name).join(",")
    @book_tags = @book.tags
    @book_new = Book.new
    @user = @book.user
    @comment = BookComment.new
    @currentUserEntry = Entry.where(user_id: current_user.id)
    @userEntry = Entry.where(user_id: @user.id)
    unless @user.id == current_user.id
      @currentUserEntry.each do |cu|
        @userEntry.each do |u|
          if cu.room_id == u.room_id
            @isRoom = true
            @roomId = cu.room_id
          end
        end
      end
      unless @isRoom
        @room = Room.new
        @entry = Entry.new
      end
    end
  end

  def edit
    @book = Book.find(params[:id])
    @tag_list = @book.tags.pluck(:name).join(",")
  end

  def update
    @book = Book.find(params[:id])
    tag_list = params[:book][:name].split(",")
    if @book.update(book_params)
      @book.save_tags(tag_list)
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

  def search_tag
    @tag_list = Tag.all
    @tag = Tag.find(params[:tag_id])
    @books = @tag.books
  end

  private
    def book_params
      params.require(:book).permit(:title, :body)
    end


    def match_user
      book = Book.find(params[:id])
      unless book.user_id == current_user.id
        redirect_to user_path(current_user)
      end
    end
end
