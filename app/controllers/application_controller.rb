class ApplicationController < ActionController::Base

  private

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
