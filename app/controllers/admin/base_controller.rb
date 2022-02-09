class Admin::BaseController < ApplicationController
  before_action :check_admin

  def check_admin
    redirect_to admin_login_path, warning: 'ログインしてください' unless current_user.admin?
  end
end
