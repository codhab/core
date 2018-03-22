module Core
  module Entity
    class ProvisonalCandidate < ActiveRecord::Base # :nodoc:
      self.table_name = 'extranet.entity_provisonal_candidates'

      belongs_to :cadastre, class_name: Core::Candidate::Cadastre, foreign_key: :candidate_id
      belongs_to :entity,   class_name: Core::Entity::Cadastre,    foreign_key: :entity_id
    end
  end
end
