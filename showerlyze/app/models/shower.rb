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

  def end_shower? water_amount
    last_dp = self.data_points.order(:created_at).last

    if last_dp and last_dp.water_amount.to_s == water_amount.to_s and self.shower_on
      self.end_time = Time.now
      self.overall_temp = self.get_overall_temp
      self.user.update_preferred_temperature self.overall_temp
      true
    else
      false
    end
  end

  def get_overall_temp
    sum, total = 0, 0
    self.data_points.order(:created_at).each do |dp|
      sum += dp.temp
      total++
    end
    sum / total
  end

end
