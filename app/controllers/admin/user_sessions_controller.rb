class Admin::UserSessionsController < Admin::BaseController
  skip_before_action :check_admin ,%i[new login]

  def new; end

  def login
  end
end
