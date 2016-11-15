class TwilioController < ApplicationController
  skip_before_filter :verify_authenticity_token
  skip_before_filter :set_current_user, :only => [:reply, :reply_to_reminder]

  def reply
    message_body = params[:Body]
    shower = Shower.find_by_id(message_body.to_i)
    shower.shower_on = true
    shower.save
    render xml: {}
  end
end
