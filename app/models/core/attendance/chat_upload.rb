module Core
  module Attendance
    class ChatUpload < ApplicationRecord
      self.table_name = 'extranet.attendance_chat_uploads'

      belongs_to :chat
    end
  end
end