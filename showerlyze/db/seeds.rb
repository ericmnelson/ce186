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
                  {:first_name => 'Lauren', :last_name => 'Capelluto',
                   :phone_number => '+15555555555', :email => 'lc@berkeley.edu',
                   :password => 'lc'},
                  # {:first_name => 'Eric', :last_name => 'Nelson',
                  #  :phone_number => '+11111111111', :email => 'en@berkeley.edu',
                  #  :password => 'en'},
                  # {:first_name => 'Jake', :last_name => 'Silhavy',
                  #  :phone_number => '+12222222222', :email => 'js@berkeley.edu',
                  #  :password => 'js'},
                  # {:first_name => 'Carol', :last_name => 'Zhang',
                  #  :phone_number => '+13333333333', :email => 'cz@berkeley.edu',
                  #  :password => 'cz'}
                 ]
                 }

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
lauren = User.find_by_first_name("Lauren")
# jake = User.find_by_first_name("Jake")
# eric = User.find_by_first_name("Eric")
# carol = User.find_by_first_name("Carol")

## SHOWERS ##
def generate_rand_start_end(hour_diff, dur_weight)
  time_now = Time.zone.now - hour_diff.hours
  rand_datetimes = [{:start_time => time_now, :end_time => time_now + 10.minutes}]
  (1..18).each do |ind|
    start = time_now - ind.days + (-5+rand(10).hours)
    rand_datetimes << {:start_time => start, :end_time => start + (5+rand(5 + dur_weight)).minutes}
  end
  return rand_datetimes
end

showers = {gige => generate_rand_start_end(0,0),
           val => generate_rand_start_end(3, 20),
           lauren => generate_rand_start_end(2, 10),
           anne => generate_rand_start_end(5, 15),
           paul => generate_rand_start_end(-2, 5),
          #  jake => generate_rand_start_end(-9, 7),
          #  eric => generate_rand_start_end(-1, 1),
          #  carol => generate_rand_start_end(-3, 9),
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


# showers = {gige => [{:start_time => "2016-11-16 03:00:00", :end_time => "2016-11-16 03:07:00"},
#                    {:start_time => "2016-11-14 03:00:00", :end_time => "2016-11-14 03:15:00"},
#                    {:start_time => "2016-11-13 03:00:00", :end_time => "2016-11-13 03:05:00"},
#                    {:start_time => "2016-11-12 03:00:00", :end_time => "2016-11-12 03:08:00"},
#                    {:start_time => "2016-11-11 03:00:00", :end_time => "2016-11-11 03:07:00"},
#                    {:start_time => "2016-11-10 03:00:00", :end_time => "2016-11-10 03:03:00"}],
#            paul => [{:start_time => "2016-11-16 03:00:00", :end_time => "2016-11-16 03:07:00"},
#                    {:start_time => "2016-11-15 03:00:00", :end_time => "2016-11-15 03:05:00"},
#                    {:start_time => "2016-11-14 03:00:00", :end_time => "2016-11-14 03:05:00"},
#                    {:start_time => "2016-11-13 03:00:00", :end_time => "2016-11-13 03:05:00"},
#                    {:start_time => "2016-11-12 03:00:00", :end_time => "2016-11-12 03:08:00"},
#                    {:start_time => "2016-11-11 03:00:00", :end_time => "2016-11-11 03:07:00"},
#                    {:start_time => "2016-11-10 03:00:00", :end_time => "2016-11-10 03:23:00"}],
#            val => [{:start_time => "2016-11-16 03:00:00", :end_time => "2016-11-16 03:37:00"},
#                   {:start_time => "2016-11-15 03:00:00", :end_time => "2016-11-15 03:35:00"},
#                   {:start_time => "2016-11-14 03:00:00", :end_time => "2016-11-14 03:35:00"},
#                   {:start_time => "2016-11-13 03:00:00", :end_time => "2016-11-13 03:25:00"},
#                   {:start_time => "2016-11-12 03:00:00", :end_time => "2016-11-12 03:28:00"},
#                   {:start_time => "2016-11-11 03:00:00", :end_time => "2016-11-11 03:17:00"},
#                   {:start_time => "2016-11-10 03:00:00", :end_time => "2016-11-10 03:43:00"}]
# }


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

## DATA POINTS ##
flow_rate = 50
temp = 90
User.all.each do |user|
  user.showers.each do |shower|
    DataPoint.create!({:shower => shower, :flow_rate => flow_rate + rand(-3..3), :temp => 75, :time => shower.start_time})
    DataPoint.create!({:shower => shower, :flow_rate => flow_rate + rand(-3..3), :temp => 76, :time => shower.start_time + 10})
    DataPoint.create!({:shower => shower, :flow_rate => flow_rate + rand(-3..3), :temp => 78, :time => shower.start_time + 20})
    DataPoint.create!({:shower => shower, :flow_rate => flow_rate + rand(-3..3), :temp => 82, :time => shower.start_time + 30})
    DataPoint.create!({:shower => shower, :flow_rate => flow_rate + rand(-3..3), :temp => 85, :time => shower.start_time + 40})
    (5...(shower.duration)/10).each do |t|
      data_point = {:shower => shower, :flow_rate => flow_rate + rand(-3..3), :temp => temp + rand(-3..3), :time => shower.start_time + (t*10)}
      DataPoint.create!(data_point)
    end
  end
end
