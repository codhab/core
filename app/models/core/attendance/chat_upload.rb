require_dependency 'core/application_record'

module Core
  module Attendance
    class ChatUpload < ApplicationRecord
      self.table_name = 'extranet.attendance_chat_uploads'

      belongs_to :chat_comment, required: false, class_name: ::Core::Attendance::Chat

      mount_uploader :document, Core::Attendance::DocumentUploader
    end
  end
end
