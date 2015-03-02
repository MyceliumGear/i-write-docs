class Gateway < ActiveRecord::Base

  nilify_blanks

  attr_reader   :straight_gateway
  attr_accessor :secret, :regenerate_secret

  belongs_to :user
  serialize :db_config, Hash
  serialize :exchange_rate_adapter_names

  validates :confirmations_required, :pubkey, :name,
            :default_currency, :user, :orders_expiration_period,
            presence: true

  validates :orders_expiration_period, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 3600 }

  validates :confirmations_required, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 6 }
  validates :name, :pubkey, uniqueness: true

  before_validation :split_exchange_rate_adapter_names!
  validate          :validate_exchange_rate_adapter_names, if: 'self.exchange_rate_adapter_names.present?'


  before_validation :decide_on_the_signature
  before_save  :generate_secret
  before_create :create_straight_gateway
  before_update :update_straight_gateway

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

  def available_exchange_rate_adapter_names
    names = Straight::ExchangeRate::Adapter.descendants.map do |a|
      a.to_s.sub("Straight::ExchangeRate::", '').sub("Adapter", '')
    end
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
      self.straight_gateway_id = @straight_gateway.id
    end

    def update_straight_gateway
      straight_gateway.update(straight_server_gateway_fields)
    end

    def straight_server_gateway_fields
      fields = {
        pubkey:           pubkey,
        name:             name,
        check_signature:  check_signature,
        default_currency: default_currency,
        active:           active,
        orders_expiration_period:    orders_expiration_period,
        confirmations_required:      confirmations_required,
        exchange_rate_adapter_names: exchange_rate_adapter_names
      }
      fields.merge!(secret: @secret) if @secret
      fields
    end

    def generate_secret
      if new_record? || (@regenerate_secret && @regenerate_secret == "1")
        @secret = String.random(64)
      end
    end

    # Decides whether this Gateway will be in "require signature" mode
    # or not. Normally that would be true, but for Widget-gateways we set
    # #check_signature to false, because widget itself creates an order - how
    # do you keep a signature secret in the frontend? Exactly.
    def decide_on_the_signature
      if self.widget
        self.check_signature = "0"
      else
        self.check_signature = "1"
      end
    end

  
end
