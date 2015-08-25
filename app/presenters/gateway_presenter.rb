class GatewayPresenter < SimpleDelegator

  def title
    if object.allow_links
      object.name.prep.html_escape(except: ['a']).urls_to_links.to_s
    else
      object.name
    end
  end
  

  private

    def object
      __getobj__
    end
end
