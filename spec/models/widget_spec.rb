require 'rails_helper'

RSpec.describe Widget, type: :model do

  it "creates a widget with multiple products" do
    widget = create(:widget, widget_products_attributes: [{ title: 'Product1', price: 1.29}, { title: 'Product2', price: 2.40 }])
    expect(widget.products).to have(2).products 
  end

end
