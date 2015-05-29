class UpdatesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :authenticate_admin!, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_update_item, only: [:show, :edit, :update, :destroy]

  def index
    @updates = UpdateItem.newest.paginate(page: params[:page], per_page: 10)
  end

  def show
  end

  def new
    @update_item = UpdateItem.new
  end

  def edit
  end

  def create
    String.hash
    @update_item = UpdateItem.new(update_item_params)

    if @update_item.save
      redirect_to updates_path, notice: 'Changelog was successfully created.'
    else
      render :new
    end
  end

  def update
    if @update_item.update(update_item_params)
      redirect_to @update_item, notice: 'Changelog was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @update_item.destroy
    redirect_to updates_url, notice: 'Changelog was successfully destroyed.'
  end

  private
    def set_update_item
      @update_item = UpdateItem.find(params[:id])
    end

    def update_item_params
      params.require(:update_item).permit(:priority, :subject, :body)
    end

    def authenticate_admin!
      render_403 unless current_user.admin?
    end
end
