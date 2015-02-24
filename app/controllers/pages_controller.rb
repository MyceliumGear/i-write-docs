class PagesController < ApplicationController

  def frontpage
    redirect_to gateways_path if current_user
  end
  
end
