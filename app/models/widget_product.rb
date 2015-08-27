class WidgetProduct < ActiveRecord::Base

  belongs_to :widget

  validates :title, :price, presence: true
  validates :title, length: { minimum: 2, maximum: 40 }
  validates :price, numericality: { greater_than: 0 }
  validates :title, format: { with: /\A[^"'<>]+\z/, message: I18n.t("widget_product.errors.title.format")}
  validates :price, 
            format: { with: /\A\d+(\.\d{1,2})\z/, message: I18n.t("widget_product.errors.price.fiat_format") },
            if: proc { |r| r.widget.gateway.default_currency != 'BTC' }
end
