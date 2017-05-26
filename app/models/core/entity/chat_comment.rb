require_dependency 'core/application_record'

module Core
  module Entity
    class ChatComment < ApplicationRecord
      self.table_name = 'extranet.entity_chat_comments'

      attr_accessor :chat_category
      
      belongs_to :chat,  required: false, class_name: ::Core::Entity::Chat
      belongs_to :staff, required: false, class_name: ::Core::Person::Staff

      belongs_to :chat_category

      has_many :chat_uploads, inverse_of: :chat_comment, class_name: ::Core::Entity::ChatUpload

   
      accepts_nested_attributes_for :chat_uploads, reject_if: :all_blank,  allow_destroy: true

    end
  end
end