require_dependency 'core/entity/chat_comment'

module Core
  module Entity
    class ChatCommentForm < Core::Attendance::ChatComment
      attr_accessor :entity_id

      validates :chat_category, presence: true
      validates :content, presence: true 
      
    end
  end
end
