require_dependency 'core/application_record'

module Core
  module Entity
    class Chat < ApplicationRecord
      self.table_name = 'extranet.entity_chats'
    end
  end
end