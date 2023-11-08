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
    if @group.save
      redirect_to groups_path
    else
      render :new
    end
  end

  def index
    @book = Book.new
    @groups = Group.all
    @user = User.find(current_user.id)
  end

  def show
    @user = current_user
    @book = Book.new
    @group = Group.find(params[:id])
    user = User.find(params[:id])
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
  end

  def edit
    @group = Group.find(params[:id])
  end

  def update
    @group = Group.find(params[:id])
    if @group.update(group_params)
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
