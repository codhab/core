require_dependency 'core/application_record'

module Core
  module Entity
    class ChatUpload < ApplicationRecord
      self.table_name = 'extranet.entity_chat_uploads'

      belongs_to :chat_comment
    end
  end
end