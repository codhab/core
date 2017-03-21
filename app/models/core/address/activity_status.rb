require_dependency 'core/application_record'

module Core
  module Address
    class ActivityStatus < ApplicationRecord
      self.table_name = 'extranet.address_activity_statuses'
      
      has_many :activities
    end
  end
end
