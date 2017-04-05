require_dependency 'core/application_policy'

module Core
  module Attendance
    class TicketPolicy < ApplicationPolicy


      def action_allow?
        true
      end

      def ticket_closed?
        [4,5,6,7].include?(self.situation_id)
      end

      def peding_with_attendant?
        self.situation_id == 2
      end

      def peding_with_supervisor?
        self.situation_id == 3
      end

      def enabled_to_update? context_id
        if [2,3].include? self.situation_id
          self.actions.where(context_id: context_id).present?
        end
      end

      def disable_remove_spouse mirror
        mirror.kinship_id != 6
      end

      def on_attendance?
        ![7,6,5,4,1].include?(self.situation_id)
      end

      def allow_close?

        # define :ticket_action_situations
        # 1 => em processo de atualização
        # 2 => atualizado
        # 3 => confirmado

        # define :ticket_situations, table: `attendance_ticket_situations`
        # 1 => pendente com candidato
        # 2 => pendente com atendente
        # 3 => pendente com supervisor
        # 4 => cancelado pelo candidato
        # 5 => deferido
        # 6 => indeferido
        # 7 => finalizado pelo candidato
        
        case self.context_id
        when 1

          return false if !self.actions.present?
          return false if self.actions.count < 4
          return false if self.situation_id != 1
          
          self.actions.each do |situation|
            return false if situation.situation_id == 1
          end
          
          return true
          
        when 2

          return false if !self.actions.present?
          return false if self.actions.count < 4

          self.actions.each do |situation|
            return false if [1,2].include? situation.situation_id
          end

          return true
        when 3
          self.actions.present? && !self.actions.where(situation_id: [1,2]).present? &&
          self.situation_id == 1
        when 4
          !self.actions.where(situation_id: [1,2]).present? &&
          self.actions.where(situation_id: [3,4]).present?
        when 5
          !self.actions.where(situation_id: [1,2]).present? &&
          self.actions.where(situation_id: [3,4]).present?
        end
      end

      

      def confirmation_required? action
        self.context.confirmation_required &&
        action.situation_id == 1 &&
        self.context_id == 1
      end

      def open? action
        [1,2].include? action.situation_id
      end

      def closed? action
        !open?(action)
      end

      def input_disabled? action
        return true if closed?(action)
        (action.situation_id == 1 && self.context.confirmation_required) &&
        self.context_id == 1
      end

    end
  end
end
