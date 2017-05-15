require_dependency 'core/application_record'

module Core
  module Candidate
    class CadastreObservation < ApplicationRecord
      self.table_name = 'extranet.candidate_cadastre_observations'
    end
  end
end
