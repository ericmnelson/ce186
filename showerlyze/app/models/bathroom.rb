class Bathroom < ActiveRecord::Base
  belongs_to :house
  has_many :showers
  has_one :current_shower, :class_name => "Shower"
end
