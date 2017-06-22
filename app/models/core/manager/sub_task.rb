require_dependency 'core/application_record'

module Core
  module Manager
    class SubTask < ApplicationRecord
      self.table_name = 'extranet.manager_sub_tasks'
    
      belongs_to :task
    end
  end
end