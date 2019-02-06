class CommentsController < ApplicationController
  before_action :require_login
  def create
    @comment = Comment.new(comment_params)
    @comment.author_id = current_user.id
    @comment.post_id = params[:post_id]

    if @comment.save!
      redirect_to post_url(@comment.post)
    else 
      flash[:errors] = @comment.errors.full_messages
      render :new
    end
  end

  def new
    render :new
  end

  private 
  def comment_params 
    params.require(:comment).permit(:content)
  end
end
