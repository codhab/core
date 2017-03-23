module Core
  module Attendance
    class TicketPolicy < ApplicationPolicy

      def allow_recadastre_cadastre? 
        allow?(1)
      end

      def allow_recadastre_income?
        allow?(2)
      end
      
      def allow_recadastre_income?
        allow?(3)
      end

      def allow_recadastre_contact?
        allow?(4)
      end

      private

      def allow? context_id
        !self.ticket_context_actions.find_by(ticket_context_id: context_id.to_i).finalizado? rescue true
      end
    end
  end
end