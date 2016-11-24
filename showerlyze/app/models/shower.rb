class Shower < ActiveRecord::Base
  belongs_to :bathroom, dependent: :destroy
  belongs_to :user, dependent: :nullify
  has_many :data_points, dependent: :nullify
  has_one :house, through: :bathroom

  def duration
    if end_time
      return end_time - start_time
    else
      return Time.now - start_time
    end
  end

  def avg_temp
    if data_points.length == 0
      return 0
    end
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
      self.bathroom.current_shower = nil
      return true
    else
      return false
    end
  end

  def get_overall_temp
    sum = 0
    self.data_points.order(:created_at).each do |dp|
      sum += dp.temp
    end
    sum / self.data_points.length
  end

end
