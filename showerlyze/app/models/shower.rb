class Shower < ActiveRecord::Base
  belongs_to :bathroom
  belongs_to :user
  has_many :temperatures

  def duration
    end_time - start_time
  end
end
