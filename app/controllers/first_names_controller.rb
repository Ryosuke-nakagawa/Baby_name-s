class FirstNamesController < ApplicationController
  before_action :set_first_names_liffid, only: %i[new]
  skip_before_action :login_required, only: %i[new login]
  before_action :first_name_set, only: %i[show destroy]

  def new; end

  def login
    lineauthenticate = LineAuthenticateService.new(params[:idToken])
    lineauthenticate.call
    user = lineauthenticate.search_user
    session[:user_id] = user.id
    group_id = { id: user.group_id }
    render json: group_id
  end

  def index
    @group = current_user.group
    @first_names = FirstName.order_by(params[:sort_type], @group.first_names)
    @sort_type = params[:sort_type].nil? ? 'overall_rating' : params[:sort_type]
  end

  def likes
    @group = current_user.group
    @like_first_names = FirstName.order_by(params[:sort_type], current_user.like_first_names)
    @sort_type = params[:sort_type].nil? ? 'overall_rating' : params[:sort_type]
  end

  def destroy
    @first_name.destroy!
    redirect_to group_first_names_path(@first_name.group),
                success: t('defaults.message.deleted', item: FirstName.model_name.human)
  end

  def show
    @group = Group.find(@first_name.group_id)
    @rate = Rate.find_by(user: current_user, first_name: @first_name)
    @rates = @first_name.rates
    @comments = @first_name.comments.includes(:user).order(created_at: :desc)
    @comment = Comment.new
    gon.first_name = @first_name
    gon.full_name = @first_name.decorate.full_name
  end

  private

  def first_name_set
    @first_name = current_user.group.first_names.find(params[:id])
  end
end
