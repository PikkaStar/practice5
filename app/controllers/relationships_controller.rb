class RelationshipsController < ApplicationController
  def create
    current_user.follow(params[:user_id])
    @user = User.find(params[:relationship][:following_id])
    redirect_to request.referer
    @user.create_notification_follow!(current_user)
  end

  def destroy
    current_user.unfollow(params[:user_id])
    redirect_to request.referer
  end

  def followings
    user = User.find(params[:user_id])
    @users = user.followings
  end

  def followers
    user = User.find(params[:user_id])
    @users = user.followers
  end
end
