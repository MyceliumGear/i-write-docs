require 'test_helper'

describe IWriteDocs::DocFilter do
  
  it "leaves only selected project blocks" do
    doc = %q{Hello.
      <<- gear
      gear text
      ->>
      <<- project2
      project text
      ->>}.gsub(/^\s+/,'')
    filtered = IWriteDocs::DocFilter.filter(doc)
    filtered.must_equal "Hello.\ngear text\n"
  end
  
end
