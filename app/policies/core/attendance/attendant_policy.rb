require_dependency 'core/application_policy'

module Core
  module Attendance
    class AttendantPolicy < ApplicationPolicy

      def attendant?

        @attendant = Core::Attendance::Attendant.find_by_staff_id(self.id)
        return false unless @attendant.present?
        return @attendant.privilege == "atendente" ? true : false
      end

      def supervisor?
        @supervisor = Core::Attendance::Attendant.find_by_staff_id(self.id)
        return false unless @supervisor.present?
        return @supervisor.privilege == "supervisor" ? true : false
      end

    end
  end
end
