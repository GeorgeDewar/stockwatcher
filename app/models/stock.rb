class Stock < ActiveRecord::Base

  def label
    "#{code} [#{name}]"
  end

  # Yesterday's close, specifically the most recent quote for this stock before today
  def yesterday_close
    Quote.where(
      'stock_id = ? and created_at = (select max(created_at) from quotes where stock_id = ? and date(created_at) < date(datetime(), \'localtime\'))',
      id, id).first
  end

  # Current price, specifically the most recent quote for this stock
  def latest_quote
    Quote.where(
      'stock_id = ? and created_at = (select max(created_at) from quotes where stock_id = ?)',
      id, id).first
  end

  def daily_diff
    QuoteDiff.new yesterday_close, latest_quote
  end

end
