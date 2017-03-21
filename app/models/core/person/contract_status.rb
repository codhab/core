module Person
  class ContractStatus < ActiveRecord::Base
    validates_presence_of :name
  end
end
