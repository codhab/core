module Core
  module Attendance
    class Ticket < ApplicationRecord
      self.table_name = 'extranet.attendance_tickets'
    end
  end
end