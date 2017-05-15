require_dependency 'core/application_record'

module Core
  module Candidate
    class ProceduralStatus < ApplicationRecord
      self.table_name = 'extranet.candidate_procedural_statuses'
    end
  end
end
