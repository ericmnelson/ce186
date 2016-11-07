class Bathroom < ActiveRecord::Base
  belongs_to :house
  has_many :showers
end
