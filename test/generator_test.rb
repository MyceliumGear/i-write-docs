require 'test_helper'

describe IWriteDocs::Generator do
  before do
    @docs_path = "./test/dummy/docs-dev"
    @build_path = "#{@docs_path}/build"
    ENV["DOCUMENTATION_PATH"] = @docs_path
    IWriteDocs::Generator.build_docs
  end
  after do
    FileUtils.remove_dir @build_path if Dir.exist? @build_path
  end

  it "create same folder structure" do
    Dir.exist?("#{@docs_path}/build").must_equal true
  end
  it "render html files with content" do
    f = File.open("#{@build_path}/changes.html", "r")
    f.read.must_equal "<h1>Overview</h1>\n"
  end
end
