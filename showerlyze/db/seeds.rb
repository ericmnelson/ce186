# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.destroy_all
Delayed::Job.destroy_all
House.destroy_all
Shower.destroy_all

## HOUSES  ##
houses = [{:name => "ATO"},
          {:name => "2622 Dana St."}]

house_instances = []
houses.each do |house|
    house_instances << House.create!(house)
end
ato, gdi = house_instances

bathroom_main = Bathroom.create!({:name => "Main Bathroom"})
bathroom_main.house = gdi
bathroom_main.save

## USERS ##
users = {gdi => [{:first_name => 'Giorgia', :last_name => 'Willits',
                   :phone_number => '7148759292', :email => 'gw@berkeley.edu',
                   :password => 'gw'},
                  {:first_name => 'Valeriya', :last_name => 'Imeshiva',
                   :phone_number => '+14444444444', :email => 'vi@berkeley.edu',
                   :password => 'vi'},
                  {:first_name => 'Anne', :last_name => 'Zeng',
                   :phone_number => '7147884536', :email => 'az@berkeley.edu',
                   :password => 'az'},
                  {:first_name => 'Pauline', :last_name => 'Duprat',
                   :phone_number => '+14444444444', :email => 'pd@berkeley.edu',
                   :password => 'pd'},
                  {:first_name => 'Yannie', :last_name => 'Yip',
                   :phone_number => '+15555555555', :email => 'yy@berkeley.edu',
                   :password => 'yy'},
                  {:first_name => 'Eric', :last_name => 'Nelson',
                   :phone_number => '+11111111111', :email => 'en@berkeley.edu',
                   :password => 'en'},
                  {:first_name => 'Jake', :last_name => 'Silhavy',
                   :phone_number => '+12222222222', :email => 'js@berkeley.edu',
                   :password => 'js'},
                  {:first_name => 'Carol', :last_name => 'Zhang',
                   :phone_number => '+13333333333', :email => 'cz@berkeley.edu',
                   :password => 'cz'}]}

user_instances = []
users.each do |house, user_hashes|
    user_hashes.each do |user|
        u = User.create!(user)
        u.house = house
        u.save
        user_instances << u
    end
end

gige = User.find_by_first_name("Giorgia")
val = User.find_by_first_name("Valeriya")
paul = User.find_by_first_name("Pauline")
anne = User.find_by_first_name("Anne")
yan = User.find_by_first_name("Yannie")

def generate_rand_start_end hour_diff
  time_now = Time.zone.now - hour_diff.hours
  rand_datetimes = [{:start_time => time_now, :end_time => time_now + 10.minutes}]
  (1..10).each do |ind|
    start = time_now - ind.days + (-5+rand(10).hours)
    rand_datetimes << {:start_time => start, :end_time => start + (5+rand(10)).minutes}
  end
  return rand_datetimes
end

showers = {gige => generate_rand_start_end(0),
           val => generate_rand_start_end(3),
           yan => generate_rand_start_end(2),
           anne => generate_rand_start_end(5),
           paul => generate_rand_start_end(-2),
         }


shower_instances = []
showers.each do |s_user, shower_hashes|
    shower_hashes.each do |shower|
        s = Shower.create!(shower)
        s.bathroom = bathroom_main
        s.user = s_user
        s.save
        shower_instances << s
    end
end
