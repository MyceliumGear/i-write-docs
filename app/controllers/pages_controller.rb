class PagesController < ApplicationController

  before_filter :authenticate_user!, only: [:docs]

  def frontpage
    if current_user
      redirect_to gateways_path
    else
      redirect_to new_user_session_path 
    end
  end

  def docs
    if params[:section].blank?
      render "pages/docs/index"
    else
      begin
        render "pages/docs/#{params[:section]}", layout: 'application'
      rescue ActionView::MissingTemplate 
        render_404
      end
    end
  end

  def test_error_reporting
    raise "This error should be reported!"
  end
  
end
