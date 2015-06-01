class UpdatesController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin!, only: [:delivery, :new, :create, :edit, :update, :destroy]
  before_action :set_update_item, only: [:delivery, :edit, :update, :destroy]
  before_action :reset_last_read_update, only: :index

  def index
    @updates = UpdateItem.newest.paginate(page: params[:page], per_page: 10)
  end

  def delivery
    if @update_item.sent_at 
      notice = "UpdateItem was already send at #{@update_item.sent_at.strftime("%b %e, %Y")}"
      return redirect_to updates_path, notice: notice
    end

    users = User.subscribed_to(@update_item.priority)
    users.find_each do |u|
      UserMailer.update_item(u, @update_item).deliver_later
    end

    @update_item.touch :sent_at
    redirect_to updates_path, notice: "#{users.count} users will get this update"
  end

  def new
    @update_item = UpdateItem.new
  end

  def edit
  end

  def create
    @update_item = UpdateItem.new(update_item_params)

    if @update_item.save
      redirect_to updates_path, notice: 'UpdateItem was successfully created.'
    else
      render :new
    end
  end

  def update
    if @update_item.update(update_item_params)
      redirect_to updates_path, notice: 'UpdateItem was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @update_item.destroy
    redirect_to updates_url, notice: 'UpdateItem was successfully destroyed.'
  end

  private

    def set_update_item
      @update_item = UpdateItem.find(params[:id])
    end

    def update_item_params
      params.require(:update_item).permit(:priority, :subject, :body)
    end

    def authenticate_admin!
      render_403 and return unless current_user.admin?
    end

    def reset_last_read_update
      if update = UpdateItem.last
        current_user.update_column(:last_read_update_id, update.id)
      end
    end
end
