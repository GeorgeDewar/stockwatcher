class AlertMailer < ActionMailer::Base
  default from: "Stock Watcher <support@stockwatcher.co.nz>"

  def stock_alert(watch, yesterday_close, current_quote, diff, percent_change)
  	@watch = watch
  	@yesterday_close = yesterday_close
  	@current_quote = current_quote

  	@direction_up = diff > 0
  	@diff = diff.abs
  	@percent_change = percent_change.abs
  	
  	mail(to: @watch.user.email, subject: "Stock Watcher alert for #{@watch.stock.label}")
  end
end
