module IWriteDocs
  class DocFilter

    START_SECTION = '<<-'
    END_SECTION   = '->>'

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
      IWriteDocs.config.subproject
    end

  end
end
