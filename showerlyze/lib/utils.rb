include ActionView::Helpers::NumberHelper
module Formattable
  def format_date date
    date.strftime("%a, %b #{date.day.ordinalize}")
  end


  ### DOLLAR AMOUNTS ###
  # default formatting: $1,000.00
  def amount_formatted
    amount_formatted_with_decimal
  end
  
  # default formatting without dollar sign: 1,000.00
  def amount_formatted_plain
    number_with_precision(self.amount, :precision => 2, :delimiter => ',')
  end
  
  # $1,000 if round dollar amount, else $1,000.30
  def amount_formatted_slim
    if self.amount % 1 == 0
      amount_formatted_without_decimal
    else
      amount_formatted_with_decimal
    end
  end
  
  # $1,000.00
  def amount_formatted_with_decimal
    "$" + number_with_precision(self.amount, :precision => 2, :delimiter => ',')
  end
  
  # $1,000
  def amount_formatted_without_decimal
    "$" + number_with_precision(self.amount, :precision => 0, :delimiter => ',')
  end
end
