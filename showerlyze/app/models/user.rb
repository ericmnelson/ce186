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
  
  def all_activities
    activities = []
    self.expenses.each do |expense|
      activities += [{:type => "expense", :object => expense}]
    end
    self.charges.each do |charge|
      activities += [{:type => "charge", :object => charge}]
    end
    activities.sort do |a, b|
      puts "A", a
      puts "B", b
      b[:object].created_at <=> a[:object].created_at
    end
  end

  def full_name
    self.first_name.capitalize + " " + self.last_name.capitalize
  end

  def first_name_initial
    self.first_name.capitalize + " " + self.last_name.capitalize[0] + "."
  end

end
