module Core
  module Attendance
    class TicketComment < ApplicationRecord
      self.table_name = 'extranet.attendance_ticket_comments'

      belongs_to :ticket
    end
  end
end
