module Protocol
  class Location < ActiveRecord::Base
    audited

    belongs_to :assessment
    belongs_to :staff, class_name: "Person::Staff"
  end
end
