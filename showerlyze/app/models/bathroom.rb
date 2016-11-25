class Bathroom < ActiveRecord::Base
  belongs_to :house
  has_many :showers do
    def current
      where(:end_time => nil).first
    end
  end
  has_many :users, through: :house
end
