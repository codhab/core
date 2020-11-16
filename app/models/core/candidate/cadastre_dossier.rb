require_dependency 'core/application_record'

module Core
  module Candidate
    class CadastreDossier < ApplicationRecord # :nodoc:
      self.table_name = 'extranet.candidate_cadastre_dossiers'
    end
  end
end
