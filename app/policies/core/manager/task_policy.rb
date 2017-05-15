module Core
  module Manager
    class TaskPolicy < ApplicationPolicy

      def allow_edit?(user_id)
        (self.project.responsible_id == user_id) ||
        (self.project.manager_id == user_id)
      end

      def allow_destroy?(user_id)
        (self.project.responsible_id == user_id) ||
        (self.project.manager_id == user_id)
      end

      def allow_update?(user_id)
        (self.project.responsible_id == user_id) ||
        (self.project.manager_id == user_id)
      end

      def allow_basic_update?(user_id)
        (self.responsible_id == user_id)
      end

    end
  end
end