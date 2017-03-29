module Core
  module Attendance
    class ChatCommentService

      def initialize(chat, comment, comments)
        @comments   = comments
        @comment    = comment
        @chat       = chat
      end

      def reading_comment!
        if @comments.where(candidate_read: false, candidate: false).present?
          new_comments = @comments.where(candidate: false)
          new_comments.update_all(candidate_read: true, candidate_read_datetime: DateTime.now)
          notifications = Core::Attendance::Notification.where(target_model: 'Core::Attendance::ChatComment', target_id: new_comments.ids)
          notifications.update_all(read: true, read_at: DateTime.now)
        end
      end

      def candidate_start_notification!
        text = 'Uma nova conversa foi inciada. Somente poderá ser iniciada outra conversa após a finalização desta. Agora faz-se necessário aguardar o retorno do atendimento da CODHAB. Você receberá notificações informando o andamento desta conversa.'
        service = Core::NotificationService.new()
        service.create(cadastre_id: @chat.cadastre_id, category_id: 1, title: "Conversa Nº #{@chat.id}/#{@chat.created_at.year} respondida pela CODHAB", content: text , target_model: @chat.class, target: @chat.id, push: true)
      end

      def candidate_notification!
        text = 'Você respondeu esta conversa. Agora faz-se necessário aguardar o retorno do atendimento da CODHAB. Você receberá notificações informando o andamento desta conversa.'
        service = Core::NotificationService.new()
        service.create(cadastre_id: @chat.cadastre_id, category_id: 1, title: "Conversa Nº #{@chat.id}/#{@chat.created_at.year} respondida pela CODHAB", content: text , target_model: @comment.class, target: @comment.id, push: true)
      end

      def codhab_notification!
        text = 'A CODHAB respondeu a esta conversa. Veja a resposta em Minhas Conversas.'
        service = Core::NotificationService.new()
        service.create(cadastre_id: @chat.cadastre_id, category_id: 1, title: "Conversa Nº #{@chat.id}/#{@chat.created_at.year} respondida pela CODHAB", content: text , target_model: @comment.class, target: @comment.id, push: true)
      end

      def finalized_notificaton!
        text = 'A CODHAB finalizou a conversa. Veja a resposta em Minhas Conversas.'
        service = Core::NotificationService.new()
        service.create(cadastre_id: @chat.cadastre_id, category_id: 1, title: "Conversa Nº #{@chat.id}/#{@chat.created_at.year} foi finalizada", content: text, target_model: @chat.class, target: @chat.id, push: true)
      end

    end
  end
end
