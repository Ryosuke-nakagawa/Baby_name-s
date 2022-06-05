class CommentsController < ApplicationController
  def create
    comment = current_user.comments.build(comment_params)
    if comment.save
      redirect_to first_name_path(comment.first_name)
    else
      redirect_to first_name_path(comment.first_name)
    end

  end

  private

  def comment_params
    params.require(:comment).permit(:body).merge(first_name_id: params[:first_name_id])
  end
end
