require_dependency 'core/attendance/document_uploader'

module Core
  module Attendance
    class TicketUpload < ApplicationRecord
      self.table_name = 'extranet.attendance_ticket_uploads'

      belongs_to :ticket_upload_category

      mount_uploader :upload_path, Core::Attendance::DocumentUploader

      validates :upload_path, presence: true

    end
  end
end
