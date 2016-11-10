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
  end
end
