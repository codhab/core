module Core
  module Attendance
    class ChatService
      def chat_create!(category, cadastre)
        @chat = Core::Attendance::Chat.new(
          chat_category_id: category,
          cadastre_id: cadastre,
          closed: false
        )
        @chat.save
        return @chat
      end
    end
  end
end
