require_dependency 'core/application_policy'

module Core
  module Manager
    class TaskPolicy < ApplicationPolicy

      def allow_edit?(user)
        (self.project.responsible_id == user.id) ||
        (self.project.manager_id == user.id) 
      end

      def allow_destroy?(user)
        (self.project.responsible_id == user.id) ||
        (self.project.manager_id == user.id)
      end

      def allow_update?(user)
        (self.project.responsible_id == user.id) ||
        (self.project.manager_id == user.id)
      end

      def allow_basic_update?(user)
        (self.responsible_id == user.id) || 
        (self.sector_id == user.sector_current_id) ||
        (self.project.manager_id == user.id) ||
        (self.project.responsible_id == user.id)
      end

    end
  end
end