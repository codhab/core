module Core
  module Attendance
    class TicketPolicy < ApplicationPolicy

      def allow_close?
        case self.context_id 
        when 1
          !self.actions.where(situation_id: [1,2]).present?
        when 2
          !self.actions.where(situation_id: [1,2]).present?
        when 3
          !self.actions.where(situation_id: [1,2]).present? &&
          self.actions.where(situation_id: [3,4]).present?
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
        action.situation_id == 1
      end

      def open? action 
        [1,2].include?(action.situation_id) 
      end

      def closed? action 
        !open?(action)
      end

      def input_disabled? action
        return true if closed?(action)
        (action.situation_id == 1 && self.context.confirmation_required)
      end
    end
  end
end