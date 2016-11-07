class TwilioController < ApplicationController
  skip_before_filter :verify_authenticity_token
  skip_before_filter :set_current_user, :only => [:reply, :reply_to_reminder]

  def reply
    message_body = params[:Body]
    from_number = params[:From].gsub(/^\+\d/, '')
    if message_body =~ /^completed ([0-9]*)/i
      request_completed_confirmation $1, from_number
    elsif message_body =~ /^confirm completed ([0-9]*)/i
      confirm_completed_charge $1, from_number
    end
    render xml: {}
  end

  def send_reminders
    expense = Expense.find_by_id(params[:expense_id])
    charges = expense.charges.where(id: params[:charge_ids])
    expense.send_reminders charges
    render json: {}
  end

  def request_completed_confirmation charge_id, from_number
      charge = Charge.find_by_id(charge_id)
      expense_name = charge.expense.name
      paid_by = charge.paid_by
      # user_charged = User.find_by_phone_number(from_number) -> check if this matches??
      user_charged = charge.charged_to
      amount = charge.amount_formatted_slim

      send_to_number = paid_by.phone_number
      message = "#{user_charged.first_name} completed your charge of #{amount} for #{expense_name}. To confirm, reply CONFIRM COMPLETED #{charge_id}"
      send_message send_to_number, message
  end

  def confirm_completed_charge charge_id, from_number
    # make sure from_number is the user who created this charge
    paid_by = User.find_by_phone_number(from_number)
    charge = Charge.find_by_id(charge_id)
    if paid_by == charge.paid_by
      # if the sender matches, mark the charge as completed
      charge.update_attributes(:completed => true)

      # send notification of completed charge to paid_by and charged_to users
      charged_to, amount, expense_name = charge.charged_to, charge.amount_formatted_slim, charge.expense.name

      message = "Your charge to #{charged_to.first_name} of #{amount} for #{expense_name} has been marked as completed."
      send_message paid_by.phone_number, message

      message = "The charge from #{paid_by.first_name} of #{amount} for #{expense_name} has been marked as completed."
      send_message charged_to.phone_number, message
    end
  end

  private

  def boot_twilio
    account_sid = ENV["TWILIO_SID"]
    auth_token = ENV["TWILIO_TOKEN"]
    @client = Twilio::REST::Client.new account_sid, auth_token
  end

  def send_message send_to, message
    boot_twilio
    sms = @client.messages.create(
      from: ENV["TWILIO_NUMBER"],
      to: send_to,
      body: message)
  end

end
