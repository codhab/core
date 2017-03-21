require_dependency 'core/application_record'
require_dependency 'core/person/staff'

module Core
  module Address
    class Activity < ApplicationRecord
      self.table_name = 'extranet.address_address_activities'

      belongs_to :unit,            required: false
      belongs_to :staff,           required: false, class_name: ::Core::Person::Staff
      belongs_to :activity_status, required: false
      

    end
  end
end
