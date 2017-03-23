require_dependency 'core/application_presenter'

module Core
  module Attendance
    class TicketPresenter < ApplicationPresenter
      
      def protocol
        "#{self.id}#{self.created_at.strftime('%Y')}"
      end

      def situation_action_by_context context_ie
        action = self.ticket_context_actions.find_by(ticket_context_id: context_id) rescue nil

        if action.present?
          action.status.humanize
        else
          "Toque para iniciar a atualização"
        end

      end

      def recadastre_icon_class context_id
        action = self.ticket_context_actions.find_by(ticket_context_id: context_id) rescue nil
        
        if action.present? 
          if action.aberto? 
            'edit blue big'
          elsif action.finalizado? || action.finalizado_pendente_análise?
            'checkmark green big' 
          end
        else
          'circle warning yellow'
        end

      end
      
    end
  end
end