module Core
  module Attendance
    class TicketPolicy < ApplicationPolicy

      def closed?
        ([2,3,4,5,6,7].include? self.ticket_status_id) 
      end

      def allow_button_recadastre?
        self.ticket_context_actions.find_by(ticket_context_id: 1, status: [1, 2]).present? &&
        self.ticket_context_actions.find_by(ticket_context_id: 2, status: [1, 2]).present? &&
        self.ticket_context_actions.find_by(ticket_context_id: 3, status: [1, 2]).present? &&
        self.ticket_context_actions.find_by(ticket_context_id: 4, status: [1, 2]).present?
      end

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