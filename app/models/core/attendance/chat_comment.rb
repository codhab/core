require_dependency 'core/application_record'

module Core
  module Attendance
    class ChatComment < ApplicationRecord
      self.table_name = 'extranet.attendance_chat_comments'

      belongs_to :chat, required: false, class_name: ::Core::Attendance::Chat

      validates :content, presence: true

    end
  end
end
