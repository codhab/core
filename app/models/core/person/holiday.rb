module Person
  class Holiday < ActiveRecord::Base
    belongs_to :staff
  end
end
