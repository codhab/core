require_dependency 'core/application_record'

module Core
  module Candidate
    class Asking < ApplicationRecord
      self.table_name = 'extranet.candidate_askings'

    end
  end
end
