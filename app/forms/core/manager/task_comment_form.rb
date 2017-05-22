require_dependency 'core/manager/project'

module Core
  module Manager
    class TaskCommentForm < ::Core::Manager::TaskComment 
      
      validates :content, presence: true
      
    end
  end
end
