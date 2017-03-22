require_dependency 'core/application_record'

module Core
  module Candidate
    class Kinship < ApplicationRecord
      self.table_name = 'extranet.candidate_kinships'

    end
  end
end
