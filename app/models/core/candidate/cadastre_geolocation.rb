require_dependency 'core/application_record'

module Core
  module Candidate
    class CadastreGeolocation < ApplicationRecord
      self.table_name = 'extranet.candidate_cadastre_geolocations'
    end
  end
end
