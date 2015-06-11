class UpdatesMailer < ApplicationMailer

  def updates_mail(user:, updates:)
    @user = user
    @updates = updates
    mail(to: @user.email)
  end

  def self.deliver_unsent_updates_later
    each_unsent_batch do |user, updates|
      updates_mail(user: user, updates: updates).deliver_later
      updates.each(&:sent!)
    end
  end

  def self.each_unsent_batch
    unsent   = UpdateItem.unsent.critical_first.newest_first.all
    counters = Hash.new { |h, k| h[k] = 0 }
    User.subscribed_to_updates.find_each do |user|
      updates = unsent.select { |update| update.interesting_for?(user) }
      unless updates.empty?
        yield user, updates
        counters[updates.size] += 1
      end
    end
    counters
  end
end
