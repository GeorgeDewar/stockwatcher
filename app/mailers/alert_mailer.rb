class AlertMailer < ActionMailer::Base
  default from: 'Stock Watcher <support@stockwatcher.co.nz>'

  def stock_alert(watch, yesterday_close, current_quote, daily_diff)
  	@watch = watch
  	@yesterday_close = yesterday_close
  	@current_quote = current_quote

  	@direction_up = daily_diff.direction == '+'
  	@diff = daily_diff.diff.abs
  	@percent_change = daily_diff.percent_change.abs
  	
  	mail(to: @watch.user.email, subject: "Stock Watcher alert for #{@watch.stock.label}")
  end
end
