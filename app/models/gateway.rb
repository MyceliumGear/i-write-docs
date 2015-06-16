class Gateway < ActiveRecord::Base

  nilify_blanks

  attr_reader   :straight_gateway
  attr_accessor :secret, :regenerate_secret, :convert_currency_to
  attr_readonly :pubkey

  belongs_to :user
  serialize :db_config, Hash
  serialize :exchange_rate_adapter_names

  validates :confirmations_required, :pubkey, :name,
            :default_currency, :user, :orders_expiration_period,
            presence: true

  validates :orders_expiration_period, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 3600 }

  validates :confirmations_required, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 6 }
  validates :name, :pubkey, uniqueness: true

  before_validation :split_exchange_rate_adapter_names!, :set_default_exchange_rate_adapter_names, :add_fallback_exchange_rate_adapter
  validate          :validate_exchange_rate_adapter_names, if: 'self.exchange_rate_adapter_names.present?'
  validate          :validate_pubkey_is_bip32
  validate :validate_address_derivation_scheme

  before_validation :decide_on_the_signature
  before_validation :assign_widget, on: :create
  before_save  :generate_secret
  before_create :create_straight_gateway
  before_update :update_straight_gateway

  has_one :widget

  scope :has_widget, -> { where(check_signature: false) }
  scope :receives_payments_notifications, -> { where(receive_payments_notifications: true) }

  after_initialize do
    self.address_derivation_scheme = "m/0/n" if new_record? && address_derivation_scheme.nil?
  end

  def straight_gateway(reload: false)
    @straight_gateway = nil if reload
    @straight_gateway ||= StraightServer::Gateway[straight_gateway_id]
  end

  def order_counters
    @order_counters ||= straight_gateway.order_counters
  end

  def orders(reload: false, conditions: {}, paginate: {})
    @orders = StraightServer::Order.where({gateway_id: straight_gateway.id}.merge(conditions))
    @orders = @orders.extension(:pagination).paginate(paginate[:page], paginate[:per_page]) if paginate.present?
    @orders = @orders.to_a
  end

  def available_exchange_rate_adapter_names
    names = Straight::ExchangeRate::Adapter.descendants.map do |a|
      a.to_s.sub("Straight::ExchangeRate::", '').sub("Adapter", '')
    end
    names.delete_if { |a| ["Bitpay", "Coinbase"].include?(a) }
    names
  end

  def convert_currency_to
    "BTC"
  end

  def has_widget?
    !check_signature
  end

  def generate_addresses(range)
    return unless straight_gateway.address_provider.instance_of?(Straight::AddressProvider::Bip32)
    range.map { |i| [i, straight_gateway.address_provider.new_address(keychain_id: i)] }
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

    def validate_pubkey_is_bip32
      begin
        MoneyTree::Node.from_bip32(pubkey)
      rescue Exception => e
        errors.add(:pubkey, "doesn't look like a BIP32 pubkey")
      end
    end

    def validate_address_derivation_scheme
      unless address_derivation_scheme.blank?
        self.address_derivation_scheme = address_derivation_scheme.to_s.strip.downcase
        valid = true
        valid &&= address_derivation_scheme.include?('n')
        valid &&= (address_derivation_scheme.split('/').uniq - %w{m n 0 1}).empty?
        unless valid
          errors.add :address_derivation_scheme, "doesn't look like address derivation scheme"
        end
      end
    end

    def create_straight_gateway
      @straight_gateway = StraightServer::Gateway.create(
        straight_server_gateway_fields.merge({order_class: "StraightServer::Order"})
      )
      self.straight_gateway_id        = @straight_gateway.id
      self.straight_gateway_hashed_id = @straight_gateway.hashed_id
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
        exchange_rate_adapter_names: exchange_rate_adapter_names,
        update_secret:               @regenerate_secret == "1",
        callback_url:                callback_url,
        address_derivation_scheme:   address_derivation_scheme,
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
      if self.site_type.present?
        self.check_signature = "0"
      else
        self.check_signature = "1"
      end
    end

    def assign_widget
      if self.site_type.present?
        self.widget = Widget.new(fields: '*Email')
      else
        self.widget.destroy if self.widget
        self.widget = nil
      end
    end

    # Exchange rate adapters ###############################

    def set_default_exchange_rate_adapter_names
      if exchange_rate_adapter_names.blank?
        self.exchange_rate_adapter_names = ["Bitstamp", "Kraken", "Btce"]
      end
    end


    def split_exchange_rate_adapter_names!
      if self.exchange_rate_adapter_names.kind_of?(String)
        self.exchange_rate_adapter_names = self.exchange_rate_adapter_names.split(/,\s*/)
      end
    end

    # Currently, some users who chose EUR may get a CurrencyNotSupported error.
    # This is because many exchange rate provides don't support it.
    # A quick hack for now is to use Bitpay, because they have lots of supported currencies.
    def add_fallback_exchange_rate_adapter
      if exchange_rate_adapter_names && exchange_rate_adapter_names.last != "Bitpay"
        self.exchange_rate_adapter_names = exchange_rate_adapter_names + ["Bitpay"]
      end
    end

    #######################################################


end
