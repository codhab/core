require_dependency 'core/application_record'

module Core
  module Candidate
    class CadastreSituation < ApplicationRecord
      self.table_name = 'extranet.candidate_cadastre_situations'

      belongs_to :situation_status,      required: false  
      belongs_to :cadastre_convocation,  required: false  
      belongs_to :cadastre,              required: false  
    end
  end
end
