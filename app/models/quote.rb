class Quote < ActiveRecord::Base
  belongs_to :stock

  class << self
	  def test
	  	logger.info "Hello test"
	  end
	end
end
