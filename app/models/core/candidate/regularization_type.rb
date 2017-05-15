require_dependency 'core/application_record'

module Core
  module Candidate
    class RegularizationType < ApplicationRecord
      self.table_name = 'extranet.candidate_regularization_types'

    end
  end
end
