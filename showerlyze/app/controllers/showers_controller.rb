class ShowersController < ApplicationController
  skip_before_filter :set_current_user, only: [:create]
  protect_from_forgery :except => [:create]

  def create
    # use bathroom & passcode to get user
    bathroom = Bathroom.find_by_id(params[:bathroom_id])

    user = bathroom.house.users.find_by_passcode(params[:passcode].downcase)
    if user
      # create a new shower
      shower = Shower.new(:bathroom => bathroom, :user => user, :shower_on => true, :temp_ready => false)
      shower.save
      # send shower id to raspberry
      render :json => {:shower_id => shower.id, :user_name => user.first_name}
    else
      render :json => {:ERROR => :NO_USER_FOUND}
    end

  def last_week
    h = House.find_by_id(params[:house_id])
    total_duration = 0
    num_showers = 0.0
    x_axis = []
    h.bathrooms.each do |b|
      showers = b.showers.where(["start_time > ?", 1.week.ago])
      num_showers =showers.length
      showers.each do |s|
        total_duration += s.duration / 60.0
      end
      shower_data = showers.group_by {|s| s.start_time.strftime("%b %e")}
      shower_data.each do |day, data|
        x_axis << day
      end
    end
    duration_week_before = 0
    num_week_before = 0.0
    h.bathrooms.each do |b|
      showers = b.showers.where(:start_time => 2.weeks.ago..1.week.ago)
      num_week_before += showers.length
      showers.each do |s|
        duration_week_before += s.duration / 60.0
      end
    end

    total_duration_change = ((total_duration / duration_week_before)-1) * 100.0
    num_showers_change = ((num_showers / num_week_before)-1) * 100.0
    render :json => {
                      "total_duration" => total_duration,
                      "total_duration_change" => total_duration_change.round,
                      "num_showers" => num_showers,
                      "num_showers_change" => num_showers_change.round,
                    }
  end

  def pie_chart_data
    h = House.find_by_id(params[:house_id])
    pie_data = {"labels" => [], "datasets" => [{"data" => []}]}
    h.bathrooms.each do |b|
      showers = b.showers.where(["start_time > ?", 1.week.ago])
      person_data = showers.group_by {|s| s.user.first_name}
      person_data.each do |name, showers|
        pie_data["labels"] << name
        sum = 0
        showers.each {|s| sum += s.duration/60.0}
        pie_data["datasets"][0]["data"] << sum
      end
    end
    render :json => pie_data
  end

  def minor
  end
end
