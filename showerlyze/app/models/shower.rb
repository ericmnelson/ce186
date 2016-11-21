class Shower < ActiveRecord::Base
  belongs_to :bathroom
  belongs_to :user
  has_many :data_points
  has_one :house, through: :bathroom

  def duration
    end_time - start_time
  end

  def avg_temp
    total = 0
    data_points.each do |dp|
      total += dp.temp
    end
    return total/data_points.length
  end

  def data
    temp = []
    flow = []
    data_points.order(:time).each do |data_point|
      temp << data_point.temp
      flow << data_point.flow_rate
    end
    {:temp => temp, :flow => flow, :start_time => start_time, :end_time => end_time}
  end
end
