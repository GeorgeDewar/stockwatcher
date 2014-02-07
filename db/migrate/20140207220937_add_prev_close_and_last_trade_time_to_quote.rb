class AddPrevCloseAndLastTradeTimeToQuote < ActiveRecord::Migration
  def change
    add_column :quotes, :last_trade_time, :datetime
    add_column :quotes, :prev_close, :decimal
  end
end
