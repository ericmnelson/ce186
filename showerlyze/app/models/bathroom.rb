class Bathroom < ActiveRecord::Base
  belongs_to :house
  has_many :showers do
    def current
      where(:end_time => nil).first
    end

    def most_recent
      where("end_time < ?", Time.now).order(:end_time).last
    end
  end
end
