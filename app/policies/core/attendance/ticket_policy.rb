module Core
  module Attendance
    class TicketPolicy < ApplicationPolicy

      def allow_recadastre_cadastre? 
        !self.ticket_context_actions.where(ticket_context_id: 1).last.finalizado?
      end
      
    end
  end
end