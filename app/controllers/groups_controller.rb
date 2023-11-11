class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user,only: [:edit,:update,:destroy]
  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    @group.owner_id = current_user.id
    @group.user_id = current_user.id
    genre_list = params[:group][:genre_name].split(",")
    if @group.save
      @group.save_genres(genre_list)
      redirect_to groups_path
    else
      render :new
    end
  end

  def index
    @book = Book.new
    @groups = Group.all
    @user = User.find(current_user.id)
    @genre_list = Genre.all
  end

  def show
    @user = current_user
    @book = Book.new
    @group = Group.find(params[:id])
    @genre_list = @group.genres.pluck(:genre_name).join(',')
    @group_genres = @group.genres
    user = User.find_by(id: params[:id])
    if user
    @currentUserEntry = Entry.where(user_id: current_user.id)
    @userEntry = Entry.where(user_id: user.id)
    unless user.id == current_user.id
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
  else
  end
  end

  def edit
    @group = Group.find(params[:id])
    @genre_list = @group.genres.pluck(:genre_name).join(',')
  end

  def update
    @group = Group.find(params[:id])
    genre_list = params[:group][:genre_name].split(',')
    if @group.update(group_params)
      @group.save_genres(genre_list)
    redirect_to groups_path
    else
    render :edit
    end
  end

  def destroy
    @group = Group.find(params[:id])
    @group.destroy
    redirect_to groups_path
  end

  def permits
    @group = Group.find(params[:id])
    @permits = @group.permits.page(params[:page])
  end

  def search_genre
    @genre_list = Genre.all
    @genre = Genre.find(params[:genre_id])
    @groups = @genre.groups
  end

  private

  def group_params
  params.require(:group).permit(:name,:introduction,:group_image)
  end

  def ensure_correct_user
      @group = Group.find(params[:id])
      unless @group.owner_id == current_user.id
        redirect_to groups_path
      end
      end
  end
