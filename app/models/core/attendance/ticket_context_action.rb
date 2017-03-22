module Core
  module Attendance    
    class TicketContextAction < ApplicationRecord
      self.table_name = 'extranet.attendance_ticket_context_actions'

      enum status: ['aberto','finalizado','cancelado']
    end
  end
end
