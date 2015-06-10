require "rails_helper"
require 'timecop'

RSpec.describe WidgetPaymentsNotificationMailer, type: :mailer do

  it "iterates over recipients and delivers mail" do
    @gateway1 = create(:widget_gateway, receive_payments_notifications: true)
    @gateway2 = create(:widget_gateway, user: @gateway1.user, receive_payments_notifications: true)
    @gateway3 = create(:widget_gateway, receive_payments_notifications: true)
    @gateway4 = create(:widget_gateway)

    @recipients = []
    described_class.each_recipient(1000) do |user, data|
      @recipients << [user, data]
    end

    expect(@recipients.size).to eq 0

    @order11 = create(:straight_order, gateway_id: @gateway1.straight_gateway_id, status: Straight::Order::STATUSES[:new])
    @order12 = create(:straight_order, gateway_id: @gateway1.straight_gateway_id, status: Straight::Order::STATUSES[:paid])
    @order21 = create(:straight_order, gateway_id: @gateway2.straight_gateway_id, status: Straight::Order::STATUSES[:unconfirmed])
    @order22 = create(:straight_order, gateway_id: @gateway2.straight_gateway_id, status: Straight::Order::STATUSES[:underpaid])
    @order23 = create(:straight_order, gateway_id: @gateway2.straight_gateway_id, status: Straight::Order::STATUSES[:expired])
    @order31 = create(:straight_order, gateway_id: @gateway3.straight_gateway_id, status: Straight::Order::STATUSES[:overpaid])
    @order41 = create(:straight_order, gateway_id: @gateway4.straight_gateway_id, status: Straight::Order::STATUSES[:paid])

    Timecop.freeze(Time.now + 1000) do
      @recipients = []
      described_class.each_recipient(1000) do |user, data|
        @recipients << [user, data]
      end
      expect(@recipients.size).to eq 0
      expect {
        described_class.deliver_all!(1000)
      }.to change { ActionMailer::Base.deliveries.count }.by(0)
    end

    @recipients = []
    described_class.each_recipient(1000) do |user, data|
      @recipients << [user, data]
    end

    expect(@recipients.size).to eq 2
    @data1 = @recipients.find { |e| e[0] == @gateway1.user }[1]
    expect(@data1.keys.map(&:straight_gateway_hashed_id).sort).to eq [@gateway1, @gateway2].map(&:straight_gateway_hashed_id).sort
    @data1.each do |k, v|
      case k.id
      when @gateway1.id
        expect(v.keys).to eq [:paid]
        expect(v.values[0].map(&:values)).to eq [@order12.values]
      when @gateway2.id
        expect(v.keys).to eq [:underpaid]
        expect(v.values[0].map(&:values)).to eq [@order22.values]
      else
        raise
      end
    end
    @data2 = @recipients.find { |e| e[0] == @gateway3.user }[1]
    expect(@data2.keys.map(&:straight_gateway_hashed_id)).to eq [@gateway3.straight_gateway_hashed_id]
    expect(@data2.values[0].keys).to eq [:overpaid]
    expect(@data2.values[0].values[0].map(&:values)).to eq [@order31.values]

    expect {
      described_class.deliver_all!(1000)
    }.to change { ActionMailer::Base.deliveries.count }.by(2)
  end
end
