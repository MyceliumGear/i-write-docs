class DeviseRegistrationsController < Devise::RegistrationsController

  before_action :configure_permitted_parameters

  def create
    build_resource(sign_up_params)

    resource.save
    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_flashing_format?
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" # if is_flashing_format?
        expire_data_after_sign_in!
        redirect_to new_user_session_path
        #respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      flash.now[:alert] = I18n.t("sign_up", scope: "devise_registrations_controller.alerts")
      clean_up_passwords resource
      #set_minimum_password_length
      respond_with resource
    end
  end


  protected def after_sign_up_path_for(_)
    wizard_path
  end

  protected def configure_permitted_parameters
    devise_parameter_sanitizer.for(:account_update) do |user_params|
      user_params.permit(
        devise_parameter_sanitizer.send(:attributes_for, :account_update) + [
          :name,
          :updates_email_subscription_level,
        ]
      )
    end
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:email, :password, :password_confirmation, :name, :tos_agreement) }
  end
end
