require_dependency 'core/application_record'

module Core
  module Attendance
    class ChatComment < ApplicationRecord
      self.table_name = 'extranet.attendance_chat_comments'

      attr_accessor :upload

      belongs_to :chat,  required: false, class_name: ::Core::Attendance::Chat
      belongs_to :staff, required: false, class_name: ::Core::Person::Staff

      validates :content, presence: true

      has_many :chat_uploads, class_name: ::Core::Attendance::ChatUpload

      accepts_nested_attributes_for :chat_uploads

    end
  end
end
