module Haml::Filters

  remove_filter 'Markdown'

  module Markdown

    include Haml::Filters::Base

    OPTIONS = {
      syntax_highlighter_opts: {
        line_numbers: false,
      },
    }

    def render(text)
      Kramdown::Document.new(text, OPTIONS).to_html
    end
  end
end
