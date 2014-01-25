class Stock < ActiveRecord::Base

  def label
    "#{code} [#{name}]"
  end

end
