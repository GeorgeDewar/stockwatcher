# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Stockwatcher::Application.initialize!

# Force time zone to NZ
Time.zone = "Auckland"
