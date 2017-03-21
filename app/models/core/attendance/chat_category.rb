module Core
  module Attendance 
    class ChatCategory < ApplicationRecord
      self.table_name = 'extranet.attendance_chat_categories'

      belongs_to :chat
    end
  end
end