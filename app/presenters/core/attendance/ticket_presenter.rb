require_dependency 'core/application_presenter'

module Core
  module Attendance
    class TicketPresenter < ApplicationPresenter
      
      def protocol
        "#{self.id}#{self.created_at.strftime('%Y')}"
      end

      def recadastre_icon_class context_id
        action = self.ticket_context_actions.where(ticket_context_id: context_id).first
        
        if action.present? 
          if action.aberto?
            'edit blue big'
          elsif action.finalizado?
            'checkmark green big'
          end
        else
          'circle warning yellow'
        end

      end
      
    end
  end
end