require_dependency 'core/application_record'

module Core
  module Candidate
    class Ammv < ApplicationRecord
      self.table_name = 'extranet.candidate_ammvs'
    end
  end
end
