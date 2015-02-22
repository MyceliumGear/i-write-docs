class Gateway < ActiveRecord::Base

  nilify_blanks

  attr_reader   :straight_gateway
  attr_accessor :secret

  belongs_to :user
  serialize :db_config, Hash
  serialize :exchange_rate_adapter_names

  validates :confirmations_required, :pubkey, :name,
            :default_currency, :check_signature, :user,
            presence: true

  validates :confirmations_required, numericality: { greater_than_or_equal_to: 0 }
  validates :name, uniqueness: true

  before_validation :split_exchange_rate_adapter_names!
  validate          :validate_exchange_rate_adapter_names, if: 'self.exchange_rate_adapter_names.present?'

  after_create :create_straight_gateway
  after_update :update_straight_gateway

  def straight_gateway(reload: false)
    @straight_gateway = nil if reload
    @straight_gateway ||= StraightServer::Gateway[straight_gateway_id]
  end

  def order_counters
    @order_counters ||= straight_gateway.order_counters
  end

  def orders(reload: false, conditions: {}, paginate: {})
    @orders = StraightServer::Order.where({gateway_id: id}.merge(conditions))
    @orders = @orders.extension(:pagination).paginate(paginate[:page], paginate[:per_page]) if paginate.present?
    @orders = @orders.to_a
  end

  private

    def validate_exchange_rate_adapter_names
      self.exchange_rate_adapter_names.each do |a|
        begin
          Kernel.const_get("Straight::ExchangeRate::#{a}Adapter")
        rescue
          errors.add(:exchange_rate_adapter_names, "includes adapter #{a}Adapter which is not available")
        end
      end
    end

    def split_exchange_rate_adapter_names!
      if self.exchange_rate_adapter_names.kind_of?(String)
        self.exchange_rate_adapter_names = self.exchange_rate_adapter_names.split(/,\s*/)
      end
    end

    def create_straight_gateway
      @straight_gateway = StraightServer::Gateway.create(
        straight_server_gateway_fields.merge({order_class: "StraightServer::Order"})
      )
      update_column(:straight_gateway_id, self.id)
    end

    def update_straight_gateway
      straight_gateway.update(straight_server_gateway_fields)
    end

    def straight_server_gateway_fields
      {
        confirmations_required: confirmations_required,
        pubkey: pubkey,
        secret: secret,
        name:   name,
        check_signature: check_signature,
        exchange_rate_adapter_names: exchange_rate_adapter_names,
        default_currency: default_currency,
        active: active
      }
    end

  
end