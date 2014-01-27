class Quote < ActiveRecord::Base
  belongs_to :stock

  require 'csv'

  class << self

  	# Retrieve current pricing for all stocks in the stocks table, and
    # put it in the quotes table
	  def update_prices
	  	stocks = Stock.all.map { |s| s.code + '.nz' }.join(',') # XRO.nz,WHS.nz etc
	  	url = URI.parse("http://download.finance.yahoo.com/d/quotes.csv?s=#{stocks}&f=sl1")
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
        # Yesterday's close, specifically the most recent quote for that stock before today
        yesterday_close = Quote.where(
          'stock_id = ? and created_at = (select max(created_at) from quotes where stock_id = ? and date(created_at) < date())', 
          watch.stock.id, watch.stock.id).first

        if(!yesterday_close) then
          puts "No previous price found for #{watch.stock.code}"
          next
        end

        # Current price, specifically the most recent quote for this stock
        current_quote = Quote.where(
          'stock_id = ? and created_at = (select max(created_at) from quotes where stock_id = ?)', 
          watch.stock.id, watch.stock.id).first

        diff = current_quote.price - yesterday_close.price
        percent_change = (diff / yesterday_close.price) * 100.0

        puts <<-eos
          \nChecking watch on '#{watch.stock.code}' for user '#{watch.user.email}'
          Yesterday's close: $#{sprintf('%0.2f', yesterday_close.price)}
          Current price: $#{sprintf('%0.2f', current_quote.price)}
          Difference: $#{sprintf('%0.2f', diff)}
          Change: #{sprintf('%0.2f', percent_change)}%
          Threshold: #{sprintf('%0.2f', watch.threshold)}%
        eos

        if diff.abs > watch.threshold then
          puts "Threshold exceeded; sending alert\n"
          AlertMailer.stock_alert(watch, yesterday_close, current_quote, diff, percent_change).deliver
        end

	    end

	  end
	end
end
