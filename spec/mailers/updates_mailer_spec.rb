require 'rails_helper'

RSpec.describe UpdatesMailer, type: :mailer do

  it "finds and delivers updates for each recipient" do
    @user = create(:user, updates_email_subscription_level: nil)
    @user0 = create(:user, updates_email_subscription_level: 0)
    @user1 = create(:user, updates_email_subscription_level: 1)
    @user2 = create(:user, updates_email_subscription_level: 2)
    @updates = []
    @updates << @update2 = create(:critical_update)
    @updates << @update12 = create(:important_update)
    @updates << @update0 = create(:regular_update)
    @updates << @update11 = create(:important_update)
    @yields = []
    @counters = described_class.each_unsent_batch do |user, updates|
      @yields << [user, updates]
    end
    expect(@yields.size).to eq 3
    expect(@counters.size).to eq 3
    @yields = @yields.to_h
    expect(@yields[@user0]).to eq [@update2, @update11, @update12, @update0]
    expect(@counters[4]).to eq 1
    expect(@yields[@user1]).to eq [@update2, @update11, @update12]
    expect(@counters[3]).to eq 1
    expect(@yields[@user2]).to eq [@update2]
    expect(@counters[1]).to eq 1

    mail_stub = double("updates_mail")
    allow(mail_stub).to receive(:deliver_later)
    allow(UpdatesMailer).to receive(:updates_mail).and_return(mail_stub)
    expect(@updates.each(&:reload).select(&:sent_at).size).to eq 0
    described_class.deliver_unsent_updates_later
    expect(mail_stub).to have_received(:deliver_later).exactly(3).times
    expect(@updates.each(&:reload).select(&:sent_at).size).to eq 4
  end
end
