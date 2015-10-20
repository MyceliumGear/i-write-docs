require 'test_helper'

describe IWriteDocs::DocFilter do
  
  it "leaves only selected project blocks" do
    doc = %q{Hello.
      <<-admin_app
      gear text
      admin_app->>
      <<- project2
      project text
      project2->>}.gsub(/^\s+/,'')
    filtered = IWriteDocs::DocFilter.filter(doc)
    filtered.must_equal "Hello.\ngear text\n\n"
  end
  
end
