module Core
  module Entity
    class ChatService

      def chat_create!(category, cadastre)
        @chat = Core::Entity::Chat.new(
          chat_category_id: category,
          entity_id: cadastre,
          closed: false
        )
        @chat.save
        return @chat
      end

    end
  end
end
