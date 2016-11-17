# app/models/user.rb

class User < ActiveRecord::Base
  has_secure_password
  has_attached_file :avatar,
    :default_url => "http://purelieve.com/wp-content/themes/massage/img/user.jpg",
    styles: {
      thumb: '100x100>',
      square: '200x200#',
      medium: '300x300>'
    }
  # Validate the attached image is image/jpg, image/png, etc
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  validates :email, uniqueness: true, format: { with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/,
    message: ": an email is incorrectly formatted" }
  validates :first_name, presence: true
  validates :last_name, presence: true

  belongs_to :house
  has_many :showers

  def avg_duration_showers
    avg = 0
    self.showers.each do |s|
      avg += s.duration / 60
    end
    if self.showers.length > 0
      return avg/self.showers.length
    else
      return 0
    end
  end

  def shower_data num_days
    temp_data = {:name => "Temperature Data",
                 :type => "spline",
                 :yAxis => 1,
                 :data => [],
                 :tooltip => {
                     valueSuffix: ' °F'
                 }
               }
    dur_data = {:name => "Daily Duration of showers",
                :type => "column",
                :data => [],
                :tooltip => {
                    valueSuffix: ' min'
                }
              }
    recent_showers = showers.where(:start_time => num_days.days.ago..Time.now).order(:start_time)
    recent_showers.each do |s|
      temp_data[:data] << [s.start_time.to_i * 1000, s.avg_temp.round(2)]
      dur_data[:data] << [s.start_time.to_i * 1000, s.duration / 60.0]
    end
    return [temp_data, dur_data]
  end

  def full_name
    self.first_name.capitalize + " " + self.last_name.capitalize
  end

  def first_name_initial
    self.first_name.capitalize + " " + self.last_name.capitalize[0] + "."
  end

end
