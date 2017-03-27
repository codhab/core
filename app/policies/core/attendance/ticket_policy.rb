module Core
  module Attendance
    class TicketPolicy < ApplicationPolicy

      def disable_remove_spouse mirror
        mirror.kinship_id != 6
      end

      def on_attendance?
        ![7,6,5,4,1].include?(self.situation_id)
      end

      def allow_close?
        case self.context_id 
        when 1

          return false if !self.actions.present?
          return false if self.actions.count < 4
          
          self.actions.each do |situation|
            return false if [1,2].include? situation.situation_id 
          end

          return true
        when 2
          self.actions.present? && !self.actions.where(situation_id: [1,2]).present? &&
          self.situation_id == 1
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

      def document_required? action
        action.uploads.any?
      end
    end
  end
end