class Quote < ActiveRecord::Base
  belongs_to :stock

  require 'csv'

  class << self
	  def test
	  	stocks = Stock.all.map { |s| s.code + '.nz' }.join(',') # XRO.nz,WHS.nz etc
	  	url = URI.parse("http://download.finance.yahoo.com/d/quotes.csv?s=#{stocks}&f=sl1")
		req = Net::HTTP::Get.new(url.to_s)
		res = Net::HTTP.start(url.host, url.port) {|http|
		  http.request(req)
		}
		
		quotes = CSV.parse(res.body)

		puts quotes

		quotes.each do |quote|
		  code = quote[0].split('.')[0] # Remove suffix, e.g. 'XRO.NZ' => 'XRO'
		  price = quote[1]
		  Quote.new(:stock => Stock.find_by_code(code), :price => price).save
		end
	  end
	end
end
