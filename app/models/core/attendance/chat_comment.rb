module Core
  module Attendance
    class ChatComment < ApplicationRecord
      self.table_name = 'extranet.attendance_chats'

      belongs_to :chat
    end
  end
end