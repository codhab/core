module Core
  module Attendance
    class TicketPolicy < ApplicationPolicy

      def confirmation_required?
        self.context.confirmation_required
      end

    end
  end
end