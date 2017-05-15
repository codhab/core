require_dependency 'core/application_policy'

module Core
  module Manager
    class TaskCommentPolicy < ApplicationPolicy

      def allow_destroy? (user_id)
        (self.commenter_id == user_id)
      end
   
    end
  end
end