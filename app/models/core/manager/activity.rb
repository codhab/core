require_dependency 'core/application_record'

module Core
  module Manager
    class Activity < ApplicationRecord
      self.table_name = 'extranet.manager_activities'
      
    end
  end
end