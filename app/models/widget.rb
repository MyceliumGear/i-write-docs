class Widget < ActiveRecord::Base

  has_many :widget_products
  alias    :products :widget_products

  accepts_nested_attributes_for :widget_products

  belongs_to :gateway
  serialize  :fields

end
