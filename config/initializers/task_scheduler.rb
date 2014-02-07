scheduler = Rufus::Scheduler.new

scheduler.every("10m") do
   	puts "--- #{DateTime.now} Updating prices ---\n"
   	Quote.update_prices
   	puts "--- Checking watches ---\n"
   	Quote.check_watches
   	puts "--- Done ---\n\n"
end 
