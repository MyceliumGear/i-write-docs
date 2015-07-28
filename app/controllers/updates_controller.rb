class UpdatesController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin!, only: [:delivery, :new, :create, :edit, :update, :destroy]
  before_action :set_update_item, only: [:delivery, :edit, :update, :destroy]
  before_action :reset_last_read_update, only: :index

  def index
    @updates = UpdateItem.newest_first.paginate(page: params[:page], per_page: 10)
  end

  def delivery
    if @update_item.sent_at
      notice = I18n.t("already_send", scope: "updates_controller.delivery", time: @update_item.sent_at.strftime("%b %e, %Y"))
      return redirect_to updates_path, notice: notice
    end

    # TODO: move to UpdatesMailer
    users = User.subscribed_to(@update_item.priority)
    users.find_each do |u|
      UserMailer.update_item(u, @update_item).deliver_later
    end

    @update_item.sent! if users.present?
    redirect_to updates_path, notice: I18n.t("users_count", scope: "updates_controller.delivery", count: users.count)
  end

  def deliver_unsent
    counters = UpdatesMailer.deliver_unsent_updates_later
    result = ''
    counters.each do |k, v|
      result.concat I18n.t("each_will_get", scope: "updates_controller.delivery", k: k, v: v)
    end
    redirect_to updates_path, notice: result.presence || I18n.t("no_one_will_get", scope: "updates_controller.delivery")
  end

  def new
    @update_item = UpdateItem.new
  end

  def edit
  end

  def create
    @update_item = UpdateItem.new(update_item_params)

    if @update_item.save
      redirect_to updates_path, notice: I18n.t("created", scope: "updates_controller.successfully")
    else
      render :new
    end
  end

  def update
    if @update_item.update(update_item_params)
      redirect_to updates_path, notice: I18n.t("updated", scope: "updates_controller.successfully")
    else
      render :edit
    end
  end

  def destroy
    @update_item.destroy
    redirect_to updates_url, notice: I18n.t("destroyed", scope: "updates_controller.successfully")
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
