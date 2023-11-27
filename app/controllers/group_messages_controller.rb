class GroupMessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    group = Group.find(params[:group_id])
    group_message = group.group_messages.build(chat_params)
    group_message.user_id = current_user.id
    redirect_to request.referer
  end

  private
    def chat_params
      params.require(:group_message).permit(:message)
    end
end
