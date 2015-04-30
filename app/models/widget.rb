class Widget < ActiveRecord::Base

  nilify_blanks

  attr_accessor :products_to_remove_ids, :product_updates

  has_many :widget_products, validate: true
  alias    :products :widget_products

  accepts_nested_attributes_for :widget_products

  belongs_to :gateway
  serialize  :fields

  validate :validate_fields

  before_validation :split_fields
  before_validation :update_products,  on: :update
  after_save  :remove_products_by_ids, on: :update

  def error_for_custom_field(field_name)
    errors[:fields].try(:first).try(:[], field_name)
  end

  private

    def remove_products_by_ids
      unless products_to_remove_ids.blank?
        products.where(id: products_to_remove_ids.split(',')).each { |product| product.delete }
        products.reload
      end
    end

    def split_fields
      write_attribute(:fields, self.fields.split(/,\s?/).uniq) unless self.fields.blank? || self.fields.kind_of?(Array)
    end

    def update_products
      products_by_id = {}
      products.each { |product| products_by_id[product.id] = product }
      product_updates.each do |product|
        product = product[1]
        products_by_id[product['id'].to_i].assign_attributes(title: product['title'], price: product['price'])
      end unless product_updates.blank?
    end

    def validate_fields
      fields_errors = {}
      if fields.kind_of?(Array)
        fields.each do |f|
          if f =~ /["'<>]/
            fields_errors[f] ||= []
            fields_errors[f] << "cannot contain the following characters: \", ', <, >"
          end
          if f.length < 2 || f.length > 30
            fields_errors[f] ||= []
            fields_errors[f] << "must be between 2 and 30 characters long"
          end
        end

        errors.add(:fields, fields_errors) unless fields_errors.empty?
      end
    end

end
