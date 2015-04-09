class PagesController < ApplicationController

  before_filter :authenticate_user!

  def frontpage
    redirect_to gateways_path if current_user
  end

  def docs
    if params[:section].blank?
      render "pages/docs/index"
    else
      begin
        render "pages/docs/#{params[:section]}"
      rescue ActionView::MissingTemplate 
        render_404
      end
    end
  end
  
end
