class PostsController < ApplicationController
  before_action :require_login, only: [:new,:create,:edit,:update,:destroy]
  before_action :require_author, only: [:update, :edit]
  def new
    @post = Post.new
    render :new
  end

  def create
    # debugger
    @post = Post.new(post_params)
    @post.author_id = current_user.id
    if @post.save!
      @post.sub_ids = params[:post][:sub_ids]

      redirect_to post_url(@post)
    else 
      flash[:errors] = @post.errors.full_messages
      render :new
    end
  end

  def update
    @post = Post.find(params[:id])

    if @post && @post.update_attributes(post_params)
      @post.save
      @post.sub_ids = params[:post][:sub_ids]
      redirect_to post_url(@post)
    else 
      flash[:errors] = @post.errors.full_messages
      render :edit
    end
  end

  def edit
    @post = Post.find(params[:id])
    @sub_ids = @post.subs.map{|sub| sub.id}
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
