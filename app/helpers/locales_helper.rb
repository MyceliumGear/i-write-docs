module LocalesHelper
  def locale_selector
    return unless I18n.available_locales.many?
    locales = []
    I18n.available_locales.each do |locale|
      if locale == I18n.locale
        locales << locale
      else
        locales << link_to(locale, change_locale_path(:locale => locale))
      end
    end
    locales.join(" | ").html_safe
  end
end
