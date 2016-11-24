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
    end
    @num_users = 5
    @available = @bathroom.current_shower.nil?
    if not @available
      @shower_user = @bathroom.current_shower.user
    end
    @total_showers = @bathroom.showers.length
  end
end
