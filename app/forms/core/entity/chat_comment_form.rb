require_dependency 'core/attendance/chat_comment'

module Core
  module Entity
    class ChatCommentForm < Core::Entity::ChatComment
      attr_accessor :entity_id

      validates :chat_category, presence: true

    end
  end
end
