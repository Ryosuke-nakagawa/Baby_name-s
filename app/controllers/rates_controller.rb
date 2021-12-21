class RatesController < ApplicationController

  def create
    @rate = Rate.create(rate_params)
    redirect_to group_first_name_path(@rate.user.group, @rate.first_name)
  end

  def update
    @rate = Rate.find(params[:id])
    @rate.update(update_rate_params)
    redirect_to group_first_name_path(@rate.user.group, @rate.first_name)
  end

  def edit
    @rate = Rate.find(params[:id])
  end

  private

  def rate_params
    params.require(:rate).permit(:sound_rate,:character_rate, :first_name_id).merge(user_id: current_user)
  end

  def update_rate_params
    params.require(:rate).permit(:sound_rate,:character_rate)
  end
end
