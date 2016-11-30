class BathroomsController < ApplicationController
  def show
    @bathroom = Bathroom.find_by_id(params[:id])
    @total_showers = @bathroom.showers.length
    @total_duration = 0
    @avg_temp = 0
    @min_temp = 10000000
    @max_temp = 0
    @max_length = 0
    @min_length = 1000000
    @price_info = {}
    @bathroom.showers.each do |s|
      dur_minute = s.duration / 60
      avg_temp = s.avg_temp
      @total_duration += dur_minute / 60
      @avg_temp +=  avg_temp / @total_showers
      if dur_minute > @max_length
        @max_length = dur_minute
      end
      if dur_minute < @min_length
        @min_length = dur_minute
      end
      if avg_temp > @max_temp
        @max_temp = avg_temp
      end
      if avg_temp < @min_temp
        @min_temp = avg_temp
      end
      if s.start_time < 7.days.ago
        if @price_info.key? s.user
          @price_info[s.user] += 2.1 * dur_minute
        else
          @price_info[s.user] = 2.1 * dur_minute
        end
      end
    end
    @total_price = (2.1 * @total_duration * 60 * 0.004).round(2)
    @num_users = 5
    @available = @bathroom.showers.current.nil?
    if not @available
      @shower_current = @bathroom.showers.current
      @shower_user = @shower_current.user
    else
      @last_shower = @bathroom.showers.most_recent

    end
    @total_showers = @bathroom.showers.length
    puts("PRICE INFO")
    puts(@price_info)
  end
end
