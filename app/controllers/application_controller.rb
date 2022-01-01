class ApplicationController < ActionController::Base
  helper_method :current_user
  before_action :login_required

  add_flash_types :success, :info, :warning, :danger

  private

  def login_required
    redirect_to root_path unless current_user
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def set_login_liffid
    gon.liff_id = ENV['LIFF_ID_LOGIN']
  end

  def set_share_target_picker_liffid
    gon.liff_id = ENV['LIFF_ID_SHARE_TARGET_PICKER']
  end

  def set_first_names_liffid
    gon.liff_id = ENV['LIFF_ID_FIRST_NAMES']
  end
end
