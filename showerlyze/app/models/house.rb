class House < ActiveRecord::Base
    has_many :users
    has_many :landlords
    has_many :bathrooms

    def showers_by_date_and_user num_days
      categories = []
      (0...num_days).each do |i|
        categories << i.days.ago.strftime("%b %e")
      end

      series = []
      self.users.each do |user|
        data = []
        (0...num_days).each do |i|
          time = 0
          user.showers.each do |shower|
            if shower.start_time.to_date === i.days.ago.to_date
              time += (shower.duration) / 60
            end
          end
          data << time
        end
        series << {:name => user.first_name, :data => data.reverse}
      end

      {:categories => categories.reverse, :series => series}
    end

    def showers_by_day_drilldown
      week = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]

      house_avgs, user_avgs = {}, {}
      week.each do |day|
        house_avgs[day] = {:num => 0, :total => 0}
        user_avgs[day] = []
      end

      self.users.each do |user|
        showers_by_day = user.showers.group_by { |shower|
          shower.start_time.strftime("%A")
        }
        showers_by_day.each do |day, showers|
          user_sum = 0
          showers.each do |shower|
            user_sum += shower.duration
          end
          house_avgs[day][:total] += user_sum
          house_avgs[day][:num] += showers.length
          user_avg = user_sum / showers.length
          user_avg /= 60
          user_avgs[day] << [user.first_name, user_avg.round(1)]
        end
      end

      series_data, drilldown_series = [], []
      {:series_data => series_data, :drilldown_series => drilldown_series, :house_avgs => house_avgs}

      week.each do |day|
        day_avg = house_avgs[day][:total]/house_avgs[day][:num]
        day_avg /= 60
        series_data << {:name => day, :y => day_avg.round(1), :drilldown => day}
        drilldown_series << {:name => day, :id => day, :data => user_avgs[day]}
      end

      {:series =>
          [{:name => "Average by Day", :colorByPoint => true, :data => series_data}],
       :drilldown =>
          {:series => drilldown_series}
      }
    end
end
