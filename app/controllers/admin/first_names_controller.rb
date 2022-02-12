class Admin::FirstNamesController < Admin::BaseController
  before_action :set_first_name, only: %i[show edit update destroy]

  def index
    @first_names = FirstName.all
  end

  def show
    @fortune_telling_image_url = S3Access.new.get_presigned_image_url(@first_name.fortune_telling_image)
  end

  def edit; end

  def update
    if @first_name.update(first_name_params)
      redirect_to admin_first_names_path
    else
      render :edit
    end
  end

  def destroy
    @first_name.destroy!
    redirect_to admin_first_names_path
  end

  private

  def set_first_name
    @first_name = FirstName.find(params[:id])
  end

  def first_name_params
    params.require(:first_name).permit(:group_id, :name, :reading)
  end
end
