class Quote < ActiveRecord::Base
  belongs_to :stock

  require 'csv'

  class << self

  	# Retrieve current pricing for all stocks in the stocks table, and
    # put it in the quotes table
	  def update_prices
	  	stocks = Stock.all.map { |s| s.code + '.nz' }.join(',') # XRO.nz,WHS.nz etc
	  	url = URI.parse("http://download.finance.yahoo.com/d/quotes.csv?s=#{stocks}&f=sl1t1d1p")
		  req = Net::HTTP::Get.new(url.to_s)
		  res = Net::HTTP.start(url.host, url.port) { |http| http.request(req) }

      puts res.body
  		quotes = CSV.parse(res.body)

  		quotes.each { |quote| update_price quote }
    end

    def update_price(quote)
      code = quote[0].split('.')[0] # Remove suffix, e.g. 'XRO.NZ' => 'XRO'
      price = quote[1]
      last_trade_time = DateTime.strptime("#{quote[3]} #{quote[2]}", '%m/%d/%Y %H:%M%P')
      last_trade_time = ActiveSupport::TimeZone['Auckland'].local_to_utc(last_trade_time)
      prev_close = quote[4]
      Quote.new(:stock => Stock.find_by_code(code), :price => price,
                :prev_close => prev_close, :last_trade_time => last_trade_time).save
    end

	  def check_watches
	    Watch.all.each do |watch|
        check_watch(watch)
      end
    end

    def check_watch(watch)
      quote = watch.stock.latest_quote

      if(!quote) then
        puts "No quotes found for #{watch.stock.code}"
        return
      end

      daily_diff = watch.stock.daily_diff

      puts <<-eos
          \nChecking watch on '#{watch.stock.code}' for user '#{watch.user.email}'
          Yesterday's close: $#{sprintf('%0.2f', quote.prev_close)}
          Latest quote: $#{sprintf('%0.2f', quote.price)} at #{quote.created_at.to_s} [ID: #{quote.id}]
          Last Trade Time: #{quote.last_trade_time.to_s}
          Difference: $#{sprintf('%0.2f', daily_diff.diff)}
          Change: #{sprintf('%0.2f', daily_diff.percent_change)}%
          Threshold: #{sprintf('%0.2f', watch.threshold)}%
      eos

      if daily_diff.percent_change.abs > watch.threshold then
        # Cheap hack - the stock market is never open for more than 16 hours
        if Alert.where("watch_id = ? and created_at > current_timestamp - interval '16 hours'", watch.id).exists? then
          puts 'Threshold exceeded; not sending alert as alert already sent within 16 hours'
        elsif quote.last_trade_time + 1.hours < Time.now
          puts 'Threshold exceeded; not sending alert as over one hour has passed since the stock was traded'
        else
          puts "Threshold exceeded; sending alert\n"
          if AlertMailer.stock_alert(watch, daily_diff).deliver_now then
            Alert.new(:watch => watch).save
          end
        end
      else
        puts 'Threshold not exceeded'
      end

    end
	end
end
