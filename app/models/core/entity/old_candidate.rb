module Core
  module Entity
    class OldCandidate < ApplicationRecord
      self.table_name = 'extranet.entity_old_candidates'

      belongs_to :old
      belongs_to :cadastre, class_name: 'Candidate::Cadastre'

    end
  end
end
