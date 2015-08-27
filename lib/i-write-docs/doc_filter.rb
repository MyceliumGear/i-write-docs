module IWriteDocs
  class DocFilter

    START_SECTION = '<<-'
    END_SECTION   = '->>'
    DEFAULT_SELECTED_PROJECT = "gear"

    attr_reader :result

    def self.filter(document)
      self.new(document).result
    end

    def initialize(doc)
      @result = grep_document(doc)
    end

  private

    def grep_document(doc)
      doc.gsub!(%r{^#{START_SECTION}(?<project>.+)\n(?<content>.*)\n#{END_SECTION}$}) do |el|
        $~[:content] if $~[:project].strip == selected_project
      end
      doc
    end
    
    def selected_project
      ENV["SELECTED_PROJECT"] || DEFAULT_SELECTED_PROJECT
    end
    
  end
end
