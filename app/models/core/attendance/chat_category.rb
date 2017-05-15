require_dependency 'core/application_record'

module Core
  module Attendance
    class ChatCategory < ApplicationRecord
      self.table_name = 'extranet.attendance_chat_categories'

      belongs_to :chat, required: false, class_name: ::Core::Attendance::Chat
    end
  end
end
