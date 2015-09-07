class UpdatesController < ApplicationController
  before_action :authenticate_user!, except: :index_for_langing_page
  before_action :authenticate_admin!, only: [:delivery, :new, :create, :edit, :update, :destroy]
  before_action :set_update_item, only: [:delivery, :edit, :update, :destroy]
  before_action :reset_last_read_update, only: :index
  after_action :allow_iframe, only: :index_for_langing_page

  def index
    @updates = updates
  end

  def index_for_langing_page
    @updates = updates
    respond_to do |format|
      format.html { render layout: 'landing' }
    end
  end

  def delivery
    if @update_item.sent_at
      notice = I18n.t("updates_controller.delivery.already_send", time: @update_item.sent_at.strftime("%b %e, %Y"))
      return redirect_to updates_path, notice: notice
    end

    # TODO: move to UpdatesMailer
    users = User.subscribed_to(@update_item.priority)
    users.find_each do |u|
      UserMailer.update_item(u, @update_item).deliver_later
    end

    @update_item.sent! if users.present?
    redirect_to updates_path, notice: I18n.t("updates_controller.delivery.users_count", count: users.count)
  end

  def deliver_unsent
    counters = UpdatesMailer.deliver_unsent_updates_later
    result = ''
    counters.each do |k, v|
      result.concat I18n.t("updates_controller.delivery.each_will_get", k: k, v: v)
    end
    redirect_to updates_path, notice: result.presence || I18n.t("updates_controller.delivery.no_one_will_get")
  end

  def new
    @update_item = UpdateItem.new
  end

  def edit
  end

  def create
    @update_item = UpdateItem.new(update_item_params)

    if @update_item.save
      redirect_to updates_path, notice: I18n.t("updates_controller.successfully.created")
    else
      render :new
    end
  end

  def update
    if @update_item.update(update_item_params)
      redirect_to updates_path, notice: I18n.t("updates_controller.successfully.updated")
    else
      render :edit
    end
  end

  def destroy
    @update_item.destroy
    redirect_to updates_url, notice: I18n.t("updates_controller.successfully.destroyed")
  end

  private

    def updates
      UpdateItem.newest_first.paginate(page: params[:page], per_page: 10)
    end

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
