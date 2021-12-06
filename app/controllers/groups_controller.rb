class GroupsController < ApplicationController
  def new
    user = User.find(session[:user_id])
    binding.pry
    @group = user.group
  end

  def update
  end
end
