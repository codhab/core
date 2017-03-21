module Core
  module Attendance  
    class TicketStatus < ApplicationRecord
      self.table_name = 'extranet.attendance_ticket_statuses'

    end
  end
end
