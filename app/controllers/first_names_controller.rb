class FirstNamesController < ApplicationController
  before_action :set_first_names_liffid, only: %i[new]
  skip_before_action :login_required, only: %i[new login]
  before_action :first_name_set, only: %i[show destroy]

  require 'net/http'
  require 'uri'

  def new; end

  def login
    result = LineAuthenticateService.new(params[:idToken]).call
    user = User.find_by(line_id: result[:line_id])
    session[:user_id] = user.id
    group_id = { id: user.group_id }
    render json: group_id
  end

  def index
    if current_user.group.id == params[:group_id].to_i
      @group = current_user.group
    else
      redirect_to group_first_names_path(current_user.group), danger: t('defaults.message.no_authorization')
      return
    end
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
    s3_access = S3Access.new
    @fortune_telling_image_url = s3_access.get_presigned_image_url(@first_name.fortune_telling_image)

    @group = Group.find(@first_name.group_id)
    @rate = Rate.find_by(user: current_user, first_name: @first_name)
    @rates = @first_name.rates
  end

  private

  def first_name_set
    @first_name = current_user.group.first_names.find(params[:id])
  end
end
