require_dependency 'core/application_record'

module Core
  module Candidate
    class InheritorType < ApplicationRecord
      self.table_name = 'extranet.candidate_inheritor_types'

    end
  end
end
