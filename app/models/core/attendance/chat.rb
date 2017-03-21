module Core
  module Attendance
    class Chat < ApplicationRecord
      self.table_name = 'extranet.attendance_chats'
  
        has_many :chat_comments
  
      belongs_to :chat_category
    end
  end
end