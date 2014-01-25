class WatchesController < ApplicationController
  before_action :set_watch, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!

  # GET /watches
  def index
    @watches = Watch.all
  end

  # GET /watches/1
  def show
  end

  # GET /watches/new
  def new
  	@stocks = Stock.all
    @watch = Watch.new
  end

  # GET /watches/1/edit
  def edit
  	@stocks = Stock.all
  end

  # POST /watches
  def create
    @watch = Watch.new(watch_params)

    if @watch.save
      flash.notice = "You're now watching #{@watch.stock.code}"
      redirect_to action: 'index'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /watches/1
  def update
    if @watch.update(watch_params)
      flash.notice = "You've successfully updated your watch"
      redirect_to action: 'index'
    else
      render action: 'edit' 
    end
  end

  # DELETE /watches/1
  def destroy
    @watch.destroy
    redirect_to watches_url
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_watch
      @watch = Watch.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def watch_params
      params.require(:watch).permit(:stock_id,:threshold)
    end
end
