class LikesController < ApplicationController
  def create
    @first_name = FirstName.find(params[:first_name_id])
    current_user.like(@first_name)
  end

  def destroy
    @first_name = current_user.likes.find(params[:id]).first_name
    current_user.unlike(@first_name)
  end
end
