require_dependency 'core/application_policy'

module Core
  module Entity
    class ChatPolicy < ApplicationPolicy

      def allow_create?
        true
      end

      def chat_closed?
        return self.order(:created_at).last.closed == true ? true : false
      end

      def allow_comment?
        return self.closed == false && self.chat_comments.order(:created_at).last.entity == false ? true : false
      end

    end
  end
end
