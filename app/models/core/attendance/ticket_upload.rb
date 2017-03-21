module Core
  module Attendance
    class TicketUpload < ApplicationRecord
      self.table_name = 'extranet.attendance_ticket_uploads'

      belongs_to :ticket_upload_category
    end
  end
end
