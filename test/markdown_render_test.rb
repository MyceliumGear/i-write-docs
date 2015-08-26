require 'test_helper'

describe IWriteDocs::MarkdownRender do

  it "render file as expected" do
    html = IWriteDocs::MarkdownRender.parse_to_html("./test/dummy/docs-dev/source/changes.md")
    html.must_equal "<h1>Overview</h1>\n"
  end
  
end
