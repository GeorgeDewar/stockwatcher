class Watch < ActiveRecord::Base
  belongs_to :user
  belongs_to :stock
end
