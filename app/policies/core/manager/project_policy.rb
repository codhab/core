require_dependency 'core/application_policy'

module Core
  module Manager
    class ProjectPolicy < ApplicationPolicy
      
      def allow_manager?(user)
        self.responsible_id == user.id ||
        self.manager_id == user.id) ||
        user.administrator?
      end

    end
  end
end