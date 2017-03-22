require_dependency 'core/application_record'

module Core
  module Candidate
    class Iptu < ApplicationRecord
      self.table_name = 'extranet.candidate_iptus'

    end
  end
end
