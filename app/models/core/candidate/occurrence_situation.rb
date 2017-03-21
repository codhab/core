module CoreCandidate
  class OccurrenceSituation < ApplicationRecord

    self.table_name = 'extranet.candidate_occurrence_situations'

    private

    def is_visible_portal?
      self.visible_portal.present?
    end
  end
end
