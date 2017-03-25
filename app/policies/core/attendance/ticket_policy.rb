module Core
  module Attendance
    class TicketPolicy < ApplicationPolicy

      def confirmation_required? action
        self.context.confirmation_required &&
        action.situation_id == 1
      end

    end
  end
end