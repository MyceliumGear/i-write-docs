require 'rails_helper'

RSpec.describe Widget, type: :model do

  before(:each) do
    @widget = create(:widget, fields: "field1, field2, *field3", widget_products_attributes: [{ title: 'Product1', price: 1.29}, { title: 'Product2', price: 2.40 }])
  end

  it "creates a widget with multiple products" do
    expect(@widget.products).to have(2).products 
  end

  it "removes products by their ids" do
    @widget.update(widget_products_attributes: [{ title: 'Product3', price: 1.29}, { title: 'Product4', price: 2.40 }])
    expect(@widget).to have(4).products
    product_ids = @widget.products[2..3].map(&:id).join(',')
    @widget.update(products_to_remove_ids: product_ids)
    expect(@widget.reload).to have(2).products
  end

  it "splits fields string into an array" do
    expect(@widget.fields).to eq(['field1', 'field2', '*field3']) 
  end

  it "updates existing prodcuts" do
    @widget.update(product_updates: [ { 'id' => @widget.products.first.id, 'attributes' => { title: 'Product3', price: 2 }} ])
    expect(@widget.products.first.price).to eq(2) 
  end

  it "invalidetes itself if any of the associated products is invalid" do
    @widget.update(product_updates: [ { 'id' => @widget.products.first.id, 'attributes' => { title: 'Product3', price: 0 }} ])
    expect(@widget.valid?).to be_falsy
  end

end
