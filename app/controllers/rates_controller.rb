class RatesController < ApplicationController
  before_action :rate_set, only: %i[update edit]

  def new
    @rate = Rate.new
    @first_name = current_user.group.first_names.find(params[:first_name_id])
  end

  def create
    @rate = Rate.create!(rate_params)
    redirect_to first_name_path(@rate.first_name),
                success: t('defaults.message.registered', item: Rate.model_name.human)
  end

  def update
    @rate = current_user.rates.find(params[:id])
    if @rate.update(rate_update_params)
      render json: { rate: @rate }, status: :ok
    else
      render json: { rate: @rate, errors: { messages: @rate.errors.full_messages } }, status: :bad_request
    end
  end

  def edit
    @first_name = current_user.group.first_names.find(params[:first_name_id])
  end

  private

  def rate_params
    params.require(:rate).permit(:sound_rate, :character_rate).merge(user_id: current_user.id,
                                                                     first_name_id: params[:first_name_id])
  end

  def rate_update_params
    params.require(:rate).permit(:sound_rate, :character_rate)
  end

  def rate_set
    @rate = current_user.rates.find(params[:id])
  end
end
