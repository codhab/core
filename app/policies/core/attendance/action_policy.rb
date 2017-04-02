require_dependency 'core/application_policy'

module Core
  module Attendance
    class ActionPolicy < ApplicationPolicy

      def document_required?

        Core::Attendance::TicketUploadCategory.all.each do |category|
          self.send(category.target_method).each do |upload|
            return true if !upload.persisted?
          end
        end
        
        return false
      end

    end
  end
end