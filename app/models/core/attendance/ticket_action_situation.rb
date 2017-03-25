module Core
  module Attendance
    class TicketActionSituation < ApplicationRecord
      self.table_name = 'extranet.attendance_ticket_action_situations'

      belongs_to :ticket
    end
  end
end
