require_dependency 'core/application_record'

module Core
  module Manager
    class TaskProblem < ApplicationRecord
      self.table_name = 'extranet.manager_task_problems'
    
      belongs_to :task
      belongs_to :responsible, class_name: ::Core::Person::Staff, foreign_key: :responsible_id
    end
  end
end