require 'test_helper'
require 'csv'

class QuoteTest < ActiveSupport::TestCase

  setup do
    @num_alerts = Alert.all.size
  end

  test "should send email when threshold exceeded" do
    Quote.check_watches

    # verify that an email was sent for each alert recorded
    num_alerts_sent = ActionMailer::Base.deliveries.size
    assert_equal num_alerts_sent, Alert.all.size - @num_alerts

    alerts = Alert.all.order(created_at: :desc).limit(num_alerts_sent)
    assert_equal 1, alerts.size
    assert alerts.first.watch == watches(:three)
  end

end
