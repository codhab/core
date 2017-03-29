module Core
  module Attendance
    class ChatPolicy < ApplicationPolicy

      def allow_create?
        true
      end

      def chat_closed?
        return self.last.closed == true ? true : false
      end

      def allow_comment?
        return self.closed == false && self.chat_comments.order(:created_at).last.candidate == false ? true : false
      end

    end
  end
end
