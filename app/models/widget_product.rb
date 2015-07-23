class WidgetProduct < ActiveRecord::Base

  belongs_to :widget

  validates :title, :price, presence: true
  validates :title, length: { minimum: 2, maximum: 40 }
  validates :price, numericality: { greater_than: 0 }
  validates :title, format: { with: /\A[^"'<>]+\z/, message: I18n.t("format", scope: "widget_product.errors.title")}

end
