class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :set_unauthenticated_layout
  before_filter :prepare_menu
  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_filter :set_locale

  rescue_from ActiveRecord::RecordNotFound, with: :render_404

  helper_method :render_to_string
  helper_method :gauth_enabled_user?

  @@layouts = YAML.load_file("#{Rails.root}/config/layouts.yml")

  # Helper method to see if user has 2fa authentication enabled
  def gauth_enabled_user?
    current_user.gauth_enabled == '1' ? true : false
  end

  def disable_recovery_unless_user_confirmed
    user = User.find_by_email(params[:user][:email])
    if user.present? && !user.confirmed?
      set_flash_message :error, :unconfirmed
      redirect_to new_user_session_path
      return
    end
  end

  private

    def set_locale
      I18n.locale = session[:locale] || preferred_language(I18n.available_locales, I18n.default_locale )
    end

    def preferred_language(supported_languages = [], default_language = :en)
      preferred_languages = accepted_locales.select {|l|
       (supported_languages || []).include?(l[0]) }
      if preferred_languages.empty?
        default_language
      else
        preferred_languages.last[0]
      end
    end

    def accepted_locales(http_accept_language = request.env["HTTP_ACCEPT_LANGUAGE"])
      return [] if http_accept_language.blank?
      langs = http_accept_language.scan(/([a-zA-Z]{2,4})(?:-[a-zA-Z]{2})?(?:;q=(1|0?\.[0-9]{1,3}))?/).map do |pair|
        lang, q = pair
        [lang.to_sym, (q || '1').to_f]
      end
      langs.sort_by { |lang, q| q }.map { |lang, q| lang }.reverse
    end

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
        format.json { render json: { type: "error", message: I18n.t("access_denied") } }
      end
    end

    def render_404
      respond_to do |format|
        format.html { render file: "#{Rails.root}/public/404", status: 404, layout: false }
        format.json { render json: { type: "error", message: I18n.t("not_found") } }
      end
    end

    def prepare_menu
      return unless current_user
      updates_icon = current_user.has_unreaded_updates? && "new_updates" || "updates"

      mmmenu do |l1|
        l1.add I18n.t("gateways", scope: "menu"), gateways_path, paths: [[gateways_path, 'get', { widget: nil } ], [new_gateway_path, 'get'] ], icon: 'gateways'
        l1.add I18n.t("widgets", scope: "menu"),  gateways_path(widget: 1), paths: [["/wizard", 'get'], [gateways_path, 'get', { widget: '1'}]], icon: 'widgets'
        l1.add I18n.t("orders", scope: "menu"),   orders_path, icon: 'orders'
        l1.add I18n.t("fiat_payouts", scope: "menu"), address_providers_path, paths: [["/fiat-payouts*"]], icon: 'fiat_payouts'
        l1.add I18n.t("account", scope: "menu"),  edit_user_registration_path, icon: 'account'
        l1.add I18n.t("documentation", scope: "menu"), "/docs", icon: 'documentation'
        l1.add I18n.t("two_factor_auth", scope: "menu"), user_displayqr_path, icon: 'two_factor_auth' unless gauth_enabled_user?
        l1.add I18n.t("updates", scope: "menu"), updates_path, icon: updates_icon
        l1.add I18n.t("sing_out", scope: "menu"), destroy_user_session_path, icon: 'sign_out'
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
