class StaticPagesController < ApplicationController
  skip_before_action :login_required, only: [:top]

  def top
  end
end
