require_dependency 'core/application_record'

module Core
  module Entity
    class Chat < ApplicationRecord
      self.table_name = 'extranet.entity_chats'

      belongs_to :chat_category, class_name: ::Core::Entity::ChatCategory
      belongs_to :entity,        class_name: ::Core::Entity::Cadastre
      belongs_to :staff,         class_name: ::Core::Person::Staff,           foreign_key: :close_staff_id

      has_many :chat_comments,   class_name: ::Core::Entity::ChatComment

      accepts_nested_attributes_for :chat_comments


    end
  end
end