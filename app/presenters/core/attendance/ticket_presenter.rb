require_dependency 'core/application_presenter'

module Core
  module Attendance
    class TicketPresenter < ApplicationPresenter
      
      def protocol
        "#{self.id}#{self.created_at.strftime('%Y')}"
      end

      def confirmation_text
        self.context.confirmation_text.html_safe rescue nil
      end

      def situation_by_action_context context_id
        action = self.actions.find_by(context_id: context_id) rescue nil

        if action.nil?
          "Toque para iniciar a atualização"
        else
          action.situation.name.humanize
        end
      end

      def icon_by_action_context context_id 
        action = self.actions.find_by(context_id: context_id) rescue nil

        if action.nil?

          case context_id
          when 1
            "gray user"
          when 2
            "gray users"
          when 3
            "gray dollar"
          when 4
            "gray phone"
          end
            
        else
          # define :ticket_action_situations
          # 1 => em processo de atualização
          # 2 => atualizado
          # 3 => confirmado
          case action.situation_id 
          when 1
            "blue flag"
          when 2
            "yellow flag"
          when 3
            "green checkmark"
          when 4
            "green checkmark"
          end

        end
      end
     
    end
  end
end