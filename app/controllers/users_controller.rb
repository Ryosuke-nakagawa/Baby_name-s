class UsersController < ApplicationController
  require 'net/http'
  require 'uri'
  
  def login; end

  def new
    
  end
  
  def create
    idToken = params[:idToken]
    channelId = '1656693818'
    res = Net::HTTP.post_form(URI.parse('https://api.line.me/oauth2/v2.1/verify'),{'id_token'=>idToken, 'client_id'=>channelId})
    line_user_id = JSON.parse(res.body)["sub"]
    user = User.find_by(line_id: line_user_id)
    binding.pry
    if user.nil? && !line_user_id.nil?
        #もしパラメーターがあるならば、そのパラメーター持つのuserの所属するgroupに入れる
        #無ければ↓
        binding.pry
        group = Group.create!
        user = User.create!(line_id: line_user_id, group: group)
        session[:user_id] = user.id
#        redirect_to group_path
    elsif user
#        session[:user_id] = user.id
#        redirect_to first_names_path(user.group)
    end
  end

end
