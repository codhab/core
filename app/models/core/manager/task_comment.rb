require_dependency 'core/application_record'

module Core
  module Manager
    class TaskComment < ApplicationRecord
      self.table_name = 'extranet.manager_task_comments'
    
      belongs_to :task
      belongs_to :commenter, class_name: ::Core::Person::Staff, foreign_key: :commenter_id
    end
  end
end