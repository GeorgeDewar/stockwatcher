require 'test_helper'

class StockTest < ActiveSupport::TestCase

  test "should get latest quote" do
    stock = stocks(:one)
    assert stock.latest_quote.created_at.to_date == Date.today
  end

  test "should give error when there are no quotes" do
    stock = stocks(:three)
    assert_raises RuntimeError do
      stock.latest_quote
    end
  end

end
