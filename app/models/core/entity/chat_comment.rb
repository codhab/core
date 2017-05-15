require_dependency 'core/application_record'

module Core
  module Entity
    class ChatComment < ApplicationRecord
      self.table_name = 'extranet.entity_chat_comments'

      belongs_to :chat_category
      has_many   :chat_uploads
    end
  end
end