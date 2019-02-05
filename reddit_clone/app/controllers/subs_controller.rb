class SubsController < ApplicationController
  before_action :require_login, only: [:update, :edit, :create, :new, :destroy]
  before_action :moderator?, only: [:edit, :update, :destroy]
  def create
    @sub = Sub.new(sub_params)
    @sub.user_id = current_user.id
    if @sub.save
      redirect_to sub_url(@sub)
    else
      flash.new[:errors] = @sub.errors.full_messages
      render :new
    end
  end
  
  def index
    @subs = Sub.all
    render :index
  end

  def new
    @sub = Sub.new
    render :new
  end

  def show
    @sub = Sub.find(params[:id])
    render :show
  end

  def edit
    @sub = Sub.find(params[:id])
    render :edit
  end

  def update
    @sub = Sub.find(params[:id])
    if @sub && @sub.update_attributes(sub_params)
      redirect.to sub_url(@sub)
    else
      flash.new[:errors] = @sub.errors.full_messages
      render :edit
    end
  end

  def destroy
    @sub = Sub.find(params[:id])
    @sub.destroy
    redirect_to subs_url
  end

  private
  def sub_params
    params.require(:sub).permit(:title, :description)
  end

  def moderator?
    sub = Sub.find(params[:id])
    current_user == sub.moderator
  end
end
