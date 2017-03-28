require_dependency 'core/attendance/document_uploader'

module Core
  module Attendance
    class TicketUpload < ApplicationRecord
      self.table_name = 'extranet.attendance_ticket_uploads'

      belongs_to :category, class_name: Core::Attendance::TicketUploadCategory, foreign_key: :category_id
      attr_accessor :disable_destroy
      
      mount_uploader :document, Core::Attendance::DocumentUploader

      def target_indentify
        "#{self.target_model}".constantize.find(self.target_id).name.humanize rescue nil
      end
    end
  end
end
