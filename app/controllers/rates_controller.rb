class RatesController < ApplicationController

  def new
    @rate = Rate.new
    @first_name = FirstName.find(params[:first_name_id])
  end

  def create
    @rate = Rate.create(rate_params)
    binding.pry
    redirect_to first_name_path(@rate.first_name)
  end

  def update
    @rate = Rate.find(params[:id])
    @rate.update(update_rate_params)
    redirect_to first_name_path(@rate.first_name)
  end

  def edit
    @rate = Rate.find(params[:id])
    @first_name = FirstName.find(params[:first_name_id])
  end

  private

  def rate_params
    params.require(:rate).permit(:sound_rate,:character_rate).merge(user_id: current_user.id, first_name_id: params[:first_name_id])
  end

  def update_rate_params
    params.require(:rate).permit(:sound_rate,:character_rate)
  end
end
