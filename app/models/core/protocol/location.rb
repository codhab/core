require_dependency 'core/application_record'
require_dependency 'core/person/staff'

module Core
  module Protocol
    class Location < ApplicationRecord
      self.table_name = 'extranet.protocol_locations'

      belongs_to :assessment,  required: false, class_name: ::Core::Protocol::Assessment
      belongs_to :staff,       required: false, class_name: ::Core::Person::Staff
    end
  end
end
