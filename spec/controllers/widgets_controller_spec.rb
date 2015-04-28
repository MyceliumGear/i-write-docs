require 'rails_helper'

RSpec.describe WidgetsController, type: :controller do

  it_should_require_signed_in_user [:update, :delete_product], :widget
  it_should_render_404_if_the_resource_was_not_found [:show, :update, :delete_product]

  describe "update action" do
    it "updates the widget and adds products"
    it "doesn't update widget if validations didn't pass"
    it "doesn't update widget if validations for one of he widget products didn't pass"
    it "doesn't allow to update widget unless user is the widget's gateway owner"
  end

  describe "delete_product action" do
    it "removes product from the widget"
    it "renders 403 unless user is the widget's gateway owner"
  end

  describe "show acction" do
    it "displays the widget"
  end

end
