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
      doc.gsub!(%r{#{START_SECTION}[ ]*(?<p>.+)\n(?<cnt>[\w\W\s]*)[ ]*(\k<p>)[ ]*#{END_SECTION}}) do |el|
        $~[:cnt] if $~[:p] == selected_project
      end
      doc
    end

    def selected_project
      IWriteDocs.config.subproject
    end

  end
end
