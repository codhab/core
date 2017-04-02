module Core
  module Attendance
    class RequerimentService

      def initialize(assessment)
        @assessment = assessment
      end

      def new_requeriment!
        text = 'Um novo requerimento foi aberto. Agora faz-se necessário aguardar o retorno do atendimento da CODHAB. Você receberá notificações informando o andamento deste requerimento.'
        service = Core::NotificationService.new()
        service.create({cadastre_id: @assessment.cadastre.id,
                        category_id: 2,
                        title: "Requerimento Nº #{@assessment.document_number} foi aberto.",
                        content: text,
                        target_model: @assessment.class,
                        target: @assessment.id,
                        push: true,
                        email: true})
      end

      def finalized_requeriment!
        text = 'Requerimento finalizado. Para verificar a resposta entre em Meus Requerimentos e acesse o nº descrito nesta notificação. '
        service = Core::NotificationService.new()
        service.create({cadastre_id: @assessment.cadastre.id,
                        category_id: 2,
                        title: "Requerimento Nº #{@assessment.document_number} foi finalizado.",
                        content: text,
                        target_model: @assessment.class,
                        target: @assessment.id,
                        push: true,
                        email: true})
      end

    end
  end
end
