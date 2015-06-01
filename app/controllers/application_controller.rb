class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :set_unauthenticated_layout
  before_filter :prepare_menu
  before_filter :configure_permitted_parameters, if: :devise_controller?

  helper_method :render_to_string
  helper_method :gauth_enabled_user?

  @@layouts = YAML.load_file("#{Rails.root}/config/layouts.yml")

  # Helper method to see if user has 2fa authentication enabled
  def gauth_enabled_user?
    current_user.gauth_enabled == '1' ? true : false
  end

  private

    # Chooses the right layout based on the config/layouts.yml file
    # which is NOT EXCLUDED from the version control.
    # This method is needed to avoid manually stating what layout we need in
    # each controller and action, espcially because we don't want to
    # generate Devise controllers.
    def set_unauthenticated_layout
      @@layouts.each do |name, controllers|
        controllers.each do |_controller, actions|

          if params[:controller] == _controller
            actions.each do |_action|
              if params[:action] == _action
                self.class.layout name.to_s
                return
              end
            end
          end

        end
      end
      self.class.layout "application"
    end

    def render_403
      respond_to do |format|
        format.html { render file: "#{Rails.root}/public/403", status: 403, layout: false }
        format.json { render json: { type: "error", message: "Error 403, you don't have permissions for this operation." } }
      end
    end

    def render_404
      respond_to do |format|
        format.html { render file: "#{Rails.root}/public/404", status: 404, layout: false }
        format.json { render json: { type: "error", message: "Error 404, resource was not found." } }
      end
    end

    def prepare_menu
      return unless current_user
      updates_icon = current_user.has_unreaded_updates? && "new_updates" || "updates"

      mmmenu do |l1|
        l1.add "GATEWAYS", gateways_path, paths: [[gateways_path, 'get', { widget: nil } ], [new_gateway_path, 'get'] ]
        l1.add "WIDGETS",  gateways_path(widget: 1), paths: [["/wizard", 'get'], [gateways_path, 'get', { widget: '1'}]]
        l1.add "ORDERS",   orders_path
        l1.add "ACCOUNT",  edit_user_registration_path
        l1.add "DOCUMENTATION", "/docs"
        l1.add "TWO FACTOR AUTH", user_displayqr_path unless gauth_enabled_user?
        l1.add "UPDATES",   updates_path, icon: updates_icon
        l1.add "SIGN OUT", destroy_user_session_path
      end 
    end

    def after_sign_in_path_for(resource)
      request.env['omniauth.origin'] || stored_location_for(resource) || '/wizard'
    end

    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up)        << :name
      devise_parameter_sanitizer.for(:account_update) << :name
    end


end
