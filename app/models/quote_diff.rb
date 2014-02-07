class QuoteDiff

  attr_accessor :quote

  def initialize(_quote)
    @quote = _quote
  end

  def diff
    @quote.price - @quote.prev_close
  end

  def percent_change
    (diff / @quote.prev_close) * 100.0
  end

  def direction
    case
      when diff > 0
        '+'
      when diff < 0
        '-'
      else
        ''
    end
  end
end