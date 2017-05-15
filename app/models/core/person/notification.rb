require_dependency 'core/application_record'

module Core
  module Person
    class Notification < ApplicationRecord
      self.table_name = 'extranet.person_notifications'
      
    end
  end
end