require_dependency 'core/application_record'

module Core
  module Candidate
    class LogSihab < ApplicationRecord
      self.table_name = 'extranet.candidate_log_sihabs'

      belongs_to :cadastre, required: false, class_name: ::Core::Candidate::Cadastre
    end
  end
end
