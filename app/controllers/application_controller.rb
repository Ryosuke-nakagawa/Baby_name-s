class ApplicationController < ActionController::Base

  private

  def set_login_liff_id
    gon.liff_id = ENV['LIFF_ID_LOGIN']
  end

  def set_share_target_picker_liff_id
    gon.liff_id = ENV['LIFF_ID_SHARE_TARGET_PICKER']
  end
end
