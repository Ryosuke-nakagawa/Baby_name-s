class StaticPagesController < ApplicationController
  skip_before_action :login_required, only: [:top]

  def top
  end

  def terms
  end

  def privacy_policy
  end

  def infomation
  end
end
