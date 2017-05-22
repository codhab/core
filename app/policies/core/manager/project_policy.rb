require_dependency 'core/application_policy'

module Core
  module Manager
    class ProjectPolicy < ApplicationPolicy
      
      def allow_manager?(user_id)
        (self.responsible_id == user_id || self.manager_id == user_id)
      end

    end
  end
end