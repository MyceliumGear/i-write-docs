require 'test_helper'

describe IWriteDocs::MarkdownRender do

  it "render file as expected" do
    html = IWriteDocs::MarkdownRender.parse_from_md_file("#{TEST_REP_PATH}/source/changes.md")
    html.must_equal "<h1>Overview</h1>\n"
  end

  it "render content from Markdown to HTML" do
    html = IWriteDocs::MarkdownRender.parse_to_html "# Header"
    html.must_equal "<h1>Header</h1>\n"
  end
  
end
