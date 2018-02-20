module Core
  module Candidate
    class CadastrePolicy < ApplicationPolicy

      def allow_recadastre_button?
        [4, 54, 68].include?(self.current_situation_id) &&
        !self.tickets.where(context_id: 1).where.not(situation_id: 1).present?
      end

      def allow_mobile_recadastre_special?
        self.current_situation_id == 70 && !self.tickets.where(context_id: 1).where.not(situation_id: 1).present?
      end

      def allow_update_button?
        ((self.program_id != 3 && self.current_situation_id == 4) &&
        self.tickets.where(context_id: 1).where.not(situation_id: 1).present?) ||
        self.program_id == 3
      end


      def active_indication_present?
        self.enterprise_cadastres.where(inactive: false).present?
      end

    end
  end
end
