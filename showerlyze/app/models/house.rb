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
              time += (shower.end_time - shower.start_time) / 60
            end
          end
          data << time
        end
        series << {:name => user.first_name, :data => data.reverse}
      end

      {:categories => categories.reverse, :series => series}
    end
end
