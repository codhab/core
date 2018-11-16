require_dependency 'core/application_record'
require_dependency 'core/person/staff'

module Core
  module Address
    class Activity < ApplicationRecord # :nodoc:
      self.table_name = 'extranet.address_activities'

      belongs_to :unit,            required: false, class_name: ::Core::Address::Unit
      belongs_to :staff,           required: false, class_name: ::Core::Person::Staff
      belongs_to :activity_status, required: false, class_name: ::Core::Address::ActivityStatus


    end
  end
end
