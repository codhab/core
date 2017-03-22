require_dependency 'core/application_record'

module Core
  module Candidate
    class OccurrenceSituation < ApplicationRecord
      self.table_name = 'extranet.candidate_occurrence_situations'

      private

      def is_visible_portal?
        self.visible_portal.present?
      end
    end
  end
end
