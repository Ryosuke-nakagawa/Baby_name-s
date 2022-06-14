class CommentsController < ApplicationController
  def create
    @comment = current_user.comments.build(comment_params)
    @comment.save
  end

  def destroy
    @comment = current_user.comments.find(params[:id])
    @comment.destroy!
    flash.now[:alert] = 'コメントを削除しました'
  end

  def update
    @comment = current_user.comments.find(params[:id])
    if @comment.update(comment_update_params)
      render json: { comment: @comment }, status: :ok
    else
      render json: { comment: @comment, errors: { messages: @comment.errors.full_messages } }, status: :bad_request
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body).merge(first_name_id: params[:first_name_id])
  end

  def comment_update_params
    params.require(:comment).permit(:body)
  end
end
