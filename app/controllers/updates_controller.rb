class UpdatesController < ApplicationController
  before_action :set_update_item, only: [:show, :edit, :update, :destroy]

  # GET /changelogs
  def index
    @update_items = UpdateItem.all
  end

  # GET /changelogs/1
  def show
  end

  # GET /changelogs/new
  def new
    @update_item = UpdateItem.new
  end

  # GET /changelogs/1/edit
  def edit
  end

  # POST /changelogs
  def create
    @update_item = UpdateItem.new(update_item_params)

    if @update_item.save
      redirect_to @update_item, notice: 'Changelog was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /changelogs/1
  def update
    if @update_item.update(changelog_params)
      redirect_to @update_item, notice: 'Changelog was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /changelogs/1
  def destroy
    @update_item.destroy
    redirect_to update_items_url, notice: 'Changelog was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_update_item
      @update_item = UpdateItem.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def update_item_params
       params.require(:changelog).permit(
        :priority,
        :subject,
        :body
      )
    end
end
