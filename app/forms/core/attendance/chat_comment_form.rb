require_dependency 'core/attendance/chat_comment'

module Core
  module Attendance
    class ChatCommentForm < Core::Attendance::ChatComment
      validates :chat_category, presence: true

    end
  end
end
