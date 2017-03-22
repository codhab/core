require_dependency 'core/application_record'

module Core
  module Candidate
    class SignedInstrument < ApplicationRecord
      self.table_name = 'extranet.candidate_signed_instruments'
    end
  end
end
