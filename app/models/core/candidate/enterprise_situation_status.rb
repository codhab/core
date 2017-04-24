require_dependency 'core/application_record'

module Core
  module Candidate
    class EnterpriseSituationStatus < ApplicationRecord # :nodoc:
      self.table_name = 'extranet.candidate_enterprise_situation_statuses'
      belongs_to :enterprise_situation_action, foreign_key: 'situation_action_id'
      has_many :enterprise_cadastre_situation

      scope :type_action,->(action) { where(situation_action_id: action) }
    end
  end
end
