require_dependency 'core/attendance/document_uploader'

module Core
  module Attendance
    class TicketUpload < ApplicationRecord
      self.table_name = 'extranet.attendance_ticket_uploads'

      attr_accessor :disable_destroy
      
      mount_uploader :document, Core::Attendance::DocumentUploader
    end
  end
end
