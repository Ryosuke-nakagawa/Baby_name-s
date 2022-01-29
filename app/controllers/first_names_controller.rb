class FirstNamesController < ApplicationController
  before_action :set_first_names_liffid, only: %i[new]
  skip_before_action :login_required, only: %i[new login]
  before_action :first_name_set, only: %i[show destroy]

  require 'net/http'
  require 'uri'

  def new; end

  def login
    line_authenticate_service = LineAuthenticateService.new(params[:idToken])
    user = User.find_by(line_id: line_authenticate_service.search_line_id)

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

    case params[:sort_type]
    when 'sound'
      @first_names = []
      result = FirstName.order_by_sound(@group.id)
      result.map { |first_name_id, _average| @first_names << FirstName.find(first_name_id) }
      @sort_type = 'sound'
    when 'character'
      @first_names = []
      result = FirstName.order_by_character(@group.id)
      result.map { |first_name_id, _average| @first_names << FirstName.find(first_name_id) }
      @sort_type = 'character'
    when 'fortune_telling'
      @first_names = FirstName.order_by_fortune_telling(@group.id)
      @sort_type = 'fortune_telling'
    else
      sort = Sort.new
      @first_names = sort.by_overall_rating(@group.first_names, @group.users)
      @sort_type = 'overall_rating'
    end
  end

  def likes
    @group = current_user.group
    like_first_names = current_user.like_first_names
    case params[:sort_type]
    when 'sound'
      @like_first_names = []
      result = like_first_names.order_by_sound(@group.id)
      result.map { |first_name_id, _average| @like_first_names << FirstName.find(first_name_id) }
      @sort_type = 'sound'
    when 'character'
      @like_first_names = []
      result = like_first_names.order_by_character(@group.id)
      result.map { |first_name_id, _average| @like_first_names << FirstName.find(first_name_id) }
      @sort_type = 'character'
    when 'fortune_telling'
      @like_first_names = like_first_names.order_by_fortune_telling(@group.id)
      @sort_type = 'fortune_telling'
    else
      sort = Sort.new
      @like_first_names = sort.by_overall_rating(like_first_names, @group.users)
      @sort_type = 'overall_rating'
    end
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
    @rates = Rate.ratings_within_group(@first_name, @group)
  end

  private

  def first_name_set
    @first_name = current_user.group.first_names.find(params[:id])
  end
end
