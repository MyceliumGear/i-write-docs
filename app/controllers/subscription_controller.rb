class SubscriptionController < ApplicationController
  before_filter :find_user

  def edit
    @auth = { token: params[:token] }
  end

  def update
    @user.update!(subscription_params)
    flash[:success] = I18n.t("devise.devise_registrations.updated")
    redirect_to new_user_session_path
  end

  private

    def find_user
      begin
        decoded_data = JWT.decode(params[:token], Rails.application.secrets.jwt_secret, true)
      rescue JWT::VerificationError, JWT::DecodeError
        flash[:error] = I18n.t("subscription.token.invalid")
        redirect_to new_user_session_path
        return
      rescue JWT::ExpiredSignature
        flash[:error] = I18n.t("subscription.token.expired")
        redirect_to new_user_session_path
        return
      end
      payload = decoded_data.first
      @user = User.find_by_email(payload.fetch('email', nil)) if payload.present?
      render_404 unless @user.present?
    end

    def subscription_params
      params.require(:user).permit(:updates_email_subscription_level)
    end
end
