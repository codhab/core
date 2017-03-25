require_dependency 'core/attendance/document_uploader'

module Core
  module Attendance
    class TicketUpload < ApplicationRecord
      self.table_name = 'extranet.attendance_ticket_uploads'

    end
  end
end
