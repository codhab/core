require_dependency 'core/application_presenter'

module Core
  module Entity
    class CadastrePresenter < ApplicationPresenter

      def current_situation_id
        self.situations.order(:id).last.situation_status.id rescue self.situations.order(:id).last.situation_status_id
      end

      def current_situation_name
        self.situations.order(:id).last.situation_status.name rescue self.situations.order(:id).last.situation_status_id
      end

      def president_name
        obj = self.members.where(member_job_id: 2).first
        obj.name.mb_chars.upcase rescue nil
      end
    end
  end
end
