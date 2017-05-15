require_dependency 'core/application_record'

module Core
  module Entity
    class ChatCategory < ApplicationRecord
      self.table_name = 'extranet.entity_chat_categories'
    end
  end
end