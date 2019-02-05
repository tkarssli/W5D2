class PostsController < ApplicationController
  before_action :require_login, only: [:new,:create,:edit,:update,:destroy]
  before_action :require_author, only: [:update, :edit]
  def new
    @post = Post.new
    render :new
  end

  def create
    @post = Post.new(post_params)
    @post.author_id = current_user.id
    @post.sub_id = params[:sub_id]

    sub_ids = post_params[:sub_ids]

    sub_ids.each do |sub_id|
      PostSub.new(post_id: @post.id, sub_id: sub_id)
    end
   

    if @post.save
      redirect_to sub_url(@post.sub)
    else 
    end
  end

  def update
    @post = Post.find(params[:id])

    if @post && @post.update_attributes(post_params)
      @post.save
      redirect_to sub_url(@post.sub)
    else 
      flash[:errors] = @post.errors.full_messages
      render :edit
    end
  end

  def edit
    @post = Post.find(params[:id])
    render :edit
  end

  def destroy    
    @post = Post.find(params[:id])
    @post.destroy 
    redirect_to sub_url(@post.sub)
  end

  def show
    @post = Post.find(params[:id])
    render :show
  end

  private 
  def require_author
    post = Post.find(params[:id])
    current_user == post.author
  end
  
  def post_params
    params.require(:post).permit(:title,:url,:content, :sub_ids)
  end
end
