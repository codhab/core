module Core
  module Candidate
    class CadastrePolicy < ApplicationPolicy

      def allow_recadastre_button?
        [4, 54].include?(self.current_situation_id) &&
        !self.tickets.where(ticket_type_id: 1).where.not(ticket_status_id: 1).present?
      end

      def allow_mobile_recadastre_special?
        self.current_situation_id == 70 && !self.tickets.where(ticket_type_id: 1).where.not(ticket_status_id: 1).present?
      end

      def allow_update_button?
        ((self.program_id != 3 && self.current_situation_id == 4) &&
        self.tickets.where(ticket_type_id: 1).where.not(ticket_status_id: 1).present?) ||
        self.program_id == 3
      end


      def active_indication_present?
        self.enterprise_cadastres.where(inactive: false).present?
      end

    end
  end
end
