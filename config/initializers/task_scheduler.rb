scheduler = Rufus::Scheduler.new

scheduler.every("3m") do
   	puts "--- Updating prices ---\n"
   	Quote.update_prices
   	puts "--- Checking watches ---\n"
   	Quote.check_watches
   	puts "--- Done ---\n\n"
end 
