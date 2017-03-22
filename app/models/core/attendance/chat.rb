require_dependency 'core/application_record'

module Core
  module Attendance
    class Chat < ApplicationRecord
      self.table_name = 'extranet.attendance_chats'

        has_many :chat_comments

        belongs_to :chat_category, required: false, class_name: ::Core::Attendance::ChatCategory

        accepts_nested_attributes_for :chat_comments
    end
  end
end
