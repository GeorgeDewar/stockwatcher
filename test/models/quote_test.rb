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

  # due to bug in Yahoo Finance API...
  test "should give correct time before and after 8pm" do
    Quote.update_price CSV.parse('"XRO.NZ",44.550,"8:27pm","3/21/2014",44.500')[0]
    assert_equal "2014-03-21 13:27:00 +1300".to_datetime, Quote.last.last_trade_time

    Quote.update_price CSV.parse('"XRO.NZ",44.600,"7:46pm","3/20/2014",44.500')[0]
    assert_equal "2014-03-21 12:46:00 +1300".to_datetime, Quote.last.last_trade_time
  end

end
