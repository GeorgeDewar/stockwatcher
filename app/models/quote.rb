class Quote < ActiveRecord::Base
  belongs_to :stock

  require 'csv'

  class << self

  	# Retrieve current pricing for all stocks in the stocks table, and
    # put it in the quotes table
	  def update_prices
	  	stocks = Stock.all.map { |s| s.code + '.nz' }.join(',') # XRO.nz,WHS.nz etc
	  	url = URI.parse("http://download.finance.yahoo.com/d/quotes.csv?s=#{stocks}&f=sl1t1d1")
		  req = Net::HTTP::Get.new(url.to_s)
		  res = Net::HTTP.start(url.host, url.port) { |http| http.request(req) }
		
  		quotes = CSV.parse(res.body)

  		puts quotes

  		quotes.each do |quote|
  		  code = quote[0].split('.')[0] # Remove suffix, e.g. 'XRO.NZ' => 'XRO'
  		  price = quote[1]
  		  Quote.new(:stock => Stock.find_by_code(code), :price => price).save
  		end
	  end

	  def check_watches
	    Watch.all.each do |watch|

        yesterday_close = watch.stock.yesterday_close

        if(!yesterday_close) then
          puts "No previous price found for #{watch.stock.code}"
          next
        end

        current_quote = watch.stock.latest_quote
        daily_diff = watch.stock.daily_diff

        puts <<-eos
          \nChecking watch on '#{watch.stock.code}' for user '#{watch.user.email}'
          Yesterday's close: $#{sprintf('%0.2f', yesterday_close.price)} at #{yesterday_close.created_at.to_s}
          Current price: $#{sprintf('%0.2f', current_quote.price)} at #{current_quote.created_at.to_s}
          Difference: $#{sprintf('%0.2f', daily_diff.diff)}
          Change: #{sprintf('%0.2f', daily_diff.percent_change)}%
          Threshold: #{sprintf('%0.2f', watch.threshold)}%
        eos

        if daily_diff.percent_change.abs > watch.threshold then
          if Alert.where("watch_id = ? and date(created_at) = date(datetime(), 'localtime')", watch.id).exists? then
            puts "Threshold exceeded; alert already sent today"
          else
            puts "Threshold exceeded; sending alert\n"
            if AlertMailer.stock_alert(watch, yesterday_close, current_quote, daily_diff).deliver then
              Alert.new(:watch => watch).save
            end
          end
        end

	    end

	  end
	end
end
