class WatchesController < ApplicationController

  def index
  	@watches = Watch.all
  end

end
