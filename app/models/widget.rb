class Widget < ActiveRecord::Base

  attr_accessor :products_to_remove_ids, :product_updates

  has_many :widget_products, validate: true
  alias    :products :widget_products

  accepts_nested_attributes_for :widget_products

  belongs_to :gateway
  serialize  :fields

  before_validation :split_fields
  before_validation :update_products,  on: :update
  after_save  :remove_products_by_ids, on: :update

  private

    def remove_products_by_ids
      unless products_to_remove_ids.blank?
        products.where(id: products_to_remove_ids.split(',')).each { |product| product.delete }
        products.reload
      end
    end

    def split_fields
      write_attribute(:fields, self.fields.split(/,\s?/)) unless self.fields.blank?
    end

    def update_products
      products_by_id = {}
      products.each { |product| products_by_id[product.id] = product }
      product_updates.each do |product|
        products_by_id[product['id']].assign_attributes(product['attributes'])
      end unless product_updates.blank?
    end

end
