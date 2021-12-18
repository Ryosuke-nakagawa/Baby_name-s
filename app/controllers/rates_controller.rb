class RatesController < ApplicationController

  def create
  end

  def update
    @rate = Rate.find(params[:id])
    @rate.update(rate_params)
    redirect_to group_first_name_path(@rate.user.group, @rate.first_name)
  end

  private

  def rate_params
    params.require(:rate).permit(:sound_rate,:character_rate)
  end
end
