module Core
  module Manager
    class TaskAttachment < ApplicationRecord
      self.table_name = 'extranet.manager_task_attachments'


      belongs_to :responsible, class_name: ::Core::Person::Staff , foreign_key: :responsible_id

      
      mount_uploader :document, Core::Manager::DocumentUploader
    end
  end
end