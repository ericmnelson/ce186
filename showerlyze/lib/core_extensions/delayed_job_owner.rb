module CoreExtensions
  class Delayed::Job < ActiveRecord::Base
    belongs_to :owner, :class_name => "Expense"
    attr_accessible :owner, :owner_type, :owner_id
  end
end  

Delayed::Job.include CoreExtensions

