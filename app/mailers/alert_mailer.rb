class AlertMailer < ActionMailer::Base
  default from: 'Stock Watcher <support@stockwatcher.co.nz>'

  def stock_alert(watch, daily_diff)
    @daily_diff = daily_diff
    @quote = daily_diff.quote
    @watch = watch

  	@direction_up = daily_diff.direction == '+'
  	@diff = daily_diff.diff.abs
  	@percent_change = daily_diff.percent_change.abs
  	
  	mail(to: @watch.user.email, subject: "Stock Watcher alert for #{@watch.stock.label}")
  end
end
