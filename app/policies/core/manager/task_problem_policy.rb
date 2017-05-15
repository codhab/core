require_dependency 'core/application_policy'

module Core
  module Manager
    class TaskProblemPolicy < ApplicationPolicy

      def allow_update?(user_id)
        (self.responsible_id == user_id)
      end
   
    end
  end
end