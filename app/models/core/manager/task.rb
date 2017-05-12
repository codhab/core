require_dependency 'core/application_record'

module Core
  module Manager
    class Task < ApplicationRecord
      self.table_name = 'extranet.manager_tasks'
      
      belongs_to :project
      belongs_to :responsible, class_name: ::Core::Person::Staff, foreign_key: :responsible_id

      has_many   :problems,    class_name: ::Core::Manager::TaskProblem,    foreign_key: :task_id, dependent: :delete_all
      has_many   :comments,    class_name: ::Core::Manager::TaskComment,    foreign_key: :task_id, dependent: :delete_all
      has_many   :attachments, class_name: ::Core::Manager::TaskAttachment, foreign_key: :task_id, dependent: :delete_all
      
      enum priority: ['baixa', 'normal', 'alta', 'urgênte']
    end
  end
end
