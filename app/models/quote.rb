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

  		quotes.each do |quote|
  		  code = quote[0].split('.')[0] # Remove suffix, e.g. 'XRO.NZ' => 'XRO'
  		  price = quote[1]
        last_trade_time = DateTime.strptime("#{quote[3]} #{quote[2]}", '%m/%d/%Y %H:%M%z').in_time_zone('Auckland')
        prev_close = quote[4]
  		  Quote.new(:stock => Stock.find_by_code(code), :price => price,
                  :prev_close => prev_close, :last_trade_time => last_trade_time).save
  		end
	  end

	  def check_watches
	    Watch.all.each do |watch|

        quote = watch.stock.latest_quote

        if(!quote) then
          puts "No quotes found for #{watch.stock.code}"
          next
        end

        daily_diff = watch.stock.daily_diff

        puts <<-eos
          \nChecking watch on '#{watch.stock.code}' for user '#{watch.user.email}'
          Yesterday's close: $#{sprintf('%0.2f', quote.prev_close)}
          Current price: $#{sprintf('%0.2f', quote.price)} at #{quote.created_at.to_s}
          Difference: $#{sprintf('%0.2f', daily_diff.diff)}
          Change: #{sprintf('%0.2f', daily_diff.percent_change)}%
          Threshold: #{sprintf('%0.2f', watch.threshold)}%
        eos

        if daily_diff.percent_change.abs > watch.threshold then
          if Alert.where("watch_id = ? and date(created_at) = date(datetime(), 'localtime')", watch.id).exists? then
            puts 'Threshold exceeded; not sending alert as alert already sent today'
          elsif quote.last_trade_time.to_date != Date.today
            puts 'Threshold exceeded; not sending alert as last trade was not today'
          else
            puts "Threshold exceeded; sending alert\n"
            if AlertMailer.stock_alert(watch, daily_diff).deliver then
              Alert.new(:watch => watch).save
            end
          end
        else
          puts 'Threshold not exceeded'
        end

	    end

	  end
	end
end
