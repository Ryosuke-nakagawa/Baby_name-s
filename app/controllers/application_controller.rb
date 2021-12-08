class ApplicationController < ActionController::Base

  private

  def set_liff_id
    gon.liff_id = ENV['LIFF_ID']
  end
end
