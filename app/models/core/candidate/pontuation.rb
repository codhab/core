require_dependency 'core/application_record'

module Core
  module Candidate
    class Pontuation < ApplicationRecord
      self.table_name = 'extranet.candidate_pontuations'

      belongs_to :cadastre_mirror,   required: false, class_name: ::Core::Candidate::CadastreMirror
      belongs_to :situation_status,  required: false, class_name: ::Core::Candidate::SituationStatus

      default_scope { order('created_at DESC')}

      def year
        if self.code.present?
          Date.parse(self.code.to_s)
        else
          self.created_at
        end
      end

    end
  end
end
