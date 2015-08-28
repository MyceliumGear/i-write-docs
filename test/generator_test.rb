require 'test_helper'

describe IWriteDocs::Generator do
  before do
    @docs_path = "./test/dummy/docs-dev"
    @build_path = "#{@docs_path}/build"
    ENV["DOCUMENTATION_PATH"] = @docs_path
  end
  after do
    FileUtils.remove_dir @build_path if Dir.exist? @build_path
  end

  describe "create html" do
    before do 
      IWriteDocs::Generator.build_docs
    end
    
    it "have same folder structure" do
      Dir.exist?("#{@build_path}").must_equal true
    end

    it "have files with content" do
      f = File.open("#{@build_path}/changes.html", "r")
      f.read.must_equal "<h1>Overview</h1>\n"
    end
  end

  describe "readme" do
    it "render readme" do
      IWriteDocs::Generator.build_readme
      readme_path = "#{@build_path}/README.md"
      File.exist?(readme_path).must_equal true
    end
  end
  
end
