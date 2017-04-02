module Core
  module Attendance
    class CadastrePolicy < ApplicationPolicy

      # Scope :attendance_tickets
      #
      # define :ticket_situations, table: `attendance_ticket_situations`
      # 1 => pendente com candidato
      # 2 => pendente com atendente
      # 3 => pendente com supervisor
      # 4 => cancelado pelo candidato
      # 5 => deferido
      # 6 => indeferido
      # 7 => finalizado pelo candidato
      
      # define :ticket_contexts table: `attendance_ticket_contexts`
      # 1 => atualização cadastral (recadastramento)
      # 2 => atualização cadastral (convocado)
      # 3 => atualização cadastral (habilitado)
      # 4 => atualização cadastral (regularização)
      # 5 => atualização cadastral (outro)

      # Scope :attendance_ticket_actions
      #
      # define :ticket_action_contexts
      # 1 => atualização dados básicos
      # 2 => atualização de dependentes 
      # 3 => atualização de renda 
      # 4 => atualização de dados de contato 

      # define :ticket_action_situations
      # 1 => em processo de atualização
      # 2 => atualizado
      # 3 => confirmado

      def allow_recadastre_update?
        !self.tickets.where(context_id: 1).where.not(situation_id: 1).present? &&
        (self.current_situation_id == 4) &&
        ![3, 6, 8].include?(self.program_id)
      end

      def allow_able_update?
        ![3, 6, 8].include?(self.program_id) &&
        (self.current_situation_id == 4) &&
        self.tickets.where(context_id: 1).where.not(situation_id: 1).present?
      end

      def allow_other_update?
        ![3,4].include?(self.current_situation_id) 
      end

      def allow_regularization_update?
        (self.program_id == 3)
      end

      def allow_convoked_update?
        ![3, 6, 8].include?(self.program_id) &&
        (self.current_situation_id == 3)
      end

      def allow_chats?
        (self.current_situation_id == 4) && [1,2].include?(self.program_id)
      end

    end
  end
end
