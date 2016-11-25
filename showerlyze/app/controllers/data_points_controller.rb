class DataPointsController < ApplicationController
  skip_before_filter :set_current_user
  protect_from_forgery :except => [:create]

  def create
    shower = Shower.find_by_id(params[:shower_id])
    if not shower.start_time
      shower.start_time = Time.now
    end

    temp = params[:temp]
    water_amount = params[:water_amount]
    data_point = DataPoint.create!(:shower => shower, :water_amount => water_amount, :temp => temp)
    pref_temp = shower.user.preferred_temp
    phone_number = shower.user.phone_number
    temp_ready = shower.temp_ready
    if (temp.to_f >= pref_temp and not shower.temp_ready)
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

    render :json => {:block_water => !shower.shower_on,
                     :end_shower => shower.end_shower?(water_amount)
                   }
  end
end
