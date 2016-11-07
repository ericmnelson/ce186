class House < ActiveRecord::Base
    has_many :users
    has_many :landlords
    has_many :bathrooms
end
