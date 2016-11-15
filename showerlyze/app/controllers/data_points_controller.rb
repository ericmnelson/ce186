class DataPointsController < ApplicationController
  skip_before_filter :set_current_user
  protect_from_forgery :except => [:create]

  def create
    shower = Shower.find_by_id(params[:shower_id])
    temp = params[:temp]
    flow = params[:flow]
    data_point = DataPoint.new(:shower => shower, :flow_rate => flow, :temp => temp)
    if not shower.start_time:
      shower.start_time = Time.now
    end
    pref_temp = shower.user.preferred_temp
    phone_number = shower.user.phone_number
    temp_ready = shower.temp_ready
    if temp.to_f >= pref_temp and not shower.temp_ready
      shower.temp_ready = true
      shower.shower_on = false
      shower.save
      @twilio_number = ENV['TWILIO_NUMBER']
      @client = Twilio::REST::Client.new ENV['TWILIO_SID'], ENV['TWILIO_TOKEN']
      message = @client.account.messages.create(
        :from => @twilio_number,
        :to => phone_number,
        :body => "Your shower is ready. Reply #{shower.id} to start.")
    end
    end_shower = false
    if flow == 0 and shower.shower_on
      end_shower = true
      shower.end_time = Time.now
    end
    render :json => {:block_water => not shower.shower_on, :end_shower => end_shower}
  end
end
