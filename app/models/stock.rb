class Stock < ActiveRecord::Base

  def label
    "#{code} [#{name}]"
  end

  # The most recent quote for this stock
  def latest_quote
    Quote.where(
      'stock_id = ? and created_at = (select max(created_at) from quotes where stock_id = ?)',
      id, id).first or raise "Could not find the latest quote for #{code}"
  end

  def daily_diff
    QuoteDiff.new latest_quote
  end

end
