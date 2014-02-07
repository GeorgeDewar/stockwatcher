class QuoteDiff

  attr_accessor :prev, :current

  def initialize(_prev, _current)
    @prev = _prev
    @current = _current
  end

  def diff
    @current.price - @prev.price
  end

  def percent_change
    (diff / @prev.price) * 100.0
  end

  def direction
    diff > 0 ? '+' : '-'
  end
end