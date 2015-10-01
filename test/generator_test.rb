require 'test_helper'

describe IWriteDocs::Generator do
  before do
    @build_path = "#{ENV['DOCUMENTATION_PATH']}/build"
  end
  after do
    FileUtils.remove_dir @build_path if Dir.exist? @build_path
  end

  describe "readme" do
    it "render readme" do
      IWriteDocs::Generator.build_readme
      readme_path = "#{@build_path}/README.md"
      File.exist?(readme_path).must_equal true
    end
  end
  
end
