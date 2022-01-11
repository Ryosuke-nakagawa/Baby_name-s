class FirstNamesController < ApplicationController
  before_action :set_first_names_liffid, only: %i[new]
  skip_before_action :login_required, only: %i[new login]
  before_action :first_name_set, only: %i[show destroy]

  require 'net/http'
  require 'uri'

  def new
  end

  def login
    idToken = params[:idToken]
    channelId = ENV['LIFF_CHANNEL_ID']
    res = Net::HTTP.post_form(URI.parse('https://api.line.me/oauth2/v2.1/verify'),{'id_token'=>idToken, 'client_id'=>channelId})
    line_user_id = JSON.parse(res.body)["sub"]
    user = User.find_by(line_id: line_user_id)

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
  
    case params[:sort]
    when 'sound'
      @first_names = []
      result = FirstName.order_by_sound(@group.id)
      result.map{ |first_name_id, average| @first_names << FirstName.find(first_name_id) }
      @sort = "音の響き"
    when 'character'
      @first_names = []
      result = FirstName.order_by_character(@group.id)
      result.map{ |first_name_id, average| @first_names << FirstName.find(first_name_id) }
      @sort = "漢字"
    when 'fotune_telling'
      @first_names = FirstName.order_by_fotune_telling(@group.id)
      @sort = "姓名判断"
    else
      @first_names = FirstName.sort_by_overall_rating(@group.first_names,@group.users)
      @sort = "総評価"
    end
  end

  def likes
    @group = current_user.group
    @like_first_names = current_user.like_first_names.order(created_at: :DESC)
  end

  def destroy
    @first_name.destroy!
    redirect_to  group_first_names_path(@first_name.group), success: t('defaults.message.deleted',item: FirstName.model_name.human)
  end

  def show
    s3 = Aws::S3::Resource.new
    signer = Aws::S3::Presigner.new(client: s3.client)
    @fotune_telling_image_url = signer.presigned_url(:get_object, bucket: ENV["AWS_BUCKET"], key: "/fotune_telling_images/#{@first_name.fotune_telling_image}", expires_in: 60)

    @group = Group.find(@first_name.group_id)
    @rate = Rate.find_by(user: current_user, first_name: @first_name)
    @rates = Rate.ratings_within_group(@first_name,@group)
  end

  private

  def first_name_set
    @first_name = current_user.group.first_names.find(params[:id])
  end
end
