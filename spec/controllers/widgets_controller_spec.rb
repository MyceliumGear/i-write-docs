require 'rails_helper'

RSpec.describe WidgetsController, type: :controller do

  it_should_require_signed_in_user [:update], :widget
  it_should_render_404_if_the_resource_was_not_found [:update]

  before(:each) do
    @gateway = create(:gateway, user: login_user)
    @widget = create(:widget, gateway: @gateway)
  end

  describe "update action" do

    it "updates the widget and adds products" do
      patch :update, id: @widget.id, widget: { fields: "email,address,name", widget_products_attributes: [{ title: 'Product1', price: 1.29 }, { title: 'Product2', price: 2.29 }]}
      expect(response).to render_template('edit')
      expect(@widget.reload.products).to have(2).products 
    end

    it "removes the products which are not on the list" do
      @widget.update(widget_products_attributes: [{ title: 'Product1', price: 1.29 }, { title: 'Product2', price: 2.29 }])
      product_1 = @widget.products.first
      patch :update, id: @widget.id, widget: { fields: "email,address,name", products_to_remove_ids: "#{product_1.id},0"}
      expect(assigns(:widget).products).to have(1).products 
    end

    it "doesn't update widget if validations for one of the widget products didn't pass" do
      patch :update, id: @widget.id, widget: { fields: "email,address,name", widget_products_attributes: [{ title: 'Product1', price: 1.29 }, { title: 'Product2', price: 0 }]}
      expect(@widget.products).to have(0).products 
    end

    it "doesn't allow to update widget unless user is the widget's gateway owner" do
      login_user
      patch :update, id: @widget.id, widget: { hello: 'world'}
      expect(response).to render_403
    end

  end

end
