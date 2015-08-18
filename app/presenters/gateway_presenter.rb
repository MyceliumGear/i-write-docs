class GatewayPresenter < BasePresenter
  presents :gateway
  
  def title
    if gateway.allow_links
      gateway.name.prep.html_escape(except: ['a']).urls_to_links.to_s
    else
      gateway.name
    end
  end

end
