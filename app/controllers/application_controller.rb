class ApplicationController < ActionController::Base
  helper_method :current_user
  before_action :login_required

  # rescue_from StandardError, with: :render500
  rescue_from ActiveRecord::RecordNotFound, with: :render404

  add_flash_types :success, :info, :warning, :danger

  private

  def login_required
    redirect_to root_path unless current_user
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def render404
    render file: Rails.root.join('public/404.html'), layout: false, status: :not_found
  end

  def render500(error = nil)
    # log/development.logに記録
    logger.error(error.message)
    logger.error(error.backtrace.join('\n'))
    ExceptionNotifier.notify_exception(error, env: request.env, data: { message: 'error' })
    render file: Rails.root.join('public/500.html'), layout: false, status: :internal_server_error
  end
end
