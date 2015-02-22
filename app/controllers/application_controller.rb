class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :set_unauthenticated_layout

  @@layouts = YAML.load_file("#{Rails.root}/config/layouts.yml")

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

end
