class Widget < ActiveRecord::Base

  attr_accessor :products_to_remove_ids

  has_many :widget_products
  alias    :products :widget_products

  accepts_nested_attributes_for :widget_products

  belongs_to :gateway
  serialize  :fields

  after_validation :remove_products_by_ids, on: :update

  private

    def remove_products_by_ids
      unless products_to_remove_ids.blank?
        products.where(id: products_to_remove_ids.split(',')).each { |product| product.delete }
        products.reload
      end
    end

end
