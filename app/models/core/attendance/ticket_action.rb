module Core
  module Attendance    
    class TicketAction < ApplicationRecord
      self.table_name = 'extranet.attendance_ticket_actions'
      
      belongs_to :situation, class_name: Core::Attendance::TicketActionSituation, foreign_key: :situation_id      
      belongs_to :context,   class_name: Core::Attendance::TicketActionContext,   foreign_key: :context_id      
    end
  end
end
