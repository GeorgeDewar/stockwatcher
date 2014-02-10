class Watch < ActiveRecord::Base
  belongs_to :user
  belongs_to :stock

  validates :stock, presence: true
  validates :threshold, presence: true, :numericality => { :greater_than => 0}

end
