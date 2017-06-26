require_dependency 'core/application_record'

module Core
  module Candidate
    class InheritorRemoved < ApplicationRecord
      self.table_name = 'extranet.candidate_inheritor_removeds'
    end
  end
end
