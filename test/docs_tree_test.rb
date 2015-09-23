require 'test_helper'

describe IWriteDocs::DocsTree do

  before(:all) do
    ENV["DOCUMENTATION_PATH"] = TEST_REP_PATH
  end
  let(:docs_instance) { IWriteDocs::DocsTree.instance }
  let(:docs_tree) { docs_instance.tree }

  it "build tree from valid config" do
    docs_tree.must_be_instance_of Tree::TreeNode
  end

  it "have for each node specific content" do
    content = {:source_path=>"source/index", :url => 'index', :title=>"Index"}
    docs_tree.first_child.content.must_equal content
  end

  it "have correct tree structure" do
    docs_tree["setup"].has_children?.must_equal true
  end

  it "returns node by given url" do
    docs_instance.find_node_by_url('index').name.must_equal 'index'
  end

  it "returns nil for bad given url" do
    docs_instance.find_node_by_url('bad_url').must_be_nil
  end

  it "returns prepared hash of previous leaf" do
    node = docs_instance.find_node_by_url('getting_started')
    docs_instance.previous_leaf(node).keys[0].must_equal 'changes'
  end

  it "returns prepare hash of next leaf" do
    node = docs_instance.find_node_by_url('getting_started')
    docs_instance.next_leaf(node).keys[0].must_equal 'setup/install-straight/basic'
  end

end

