require_dependency 'core/application_record'

module Core
  module Regularization
    class SolicitationSubject < ApplicationRecord
      self.table_name = 'extranet.regularization_solicitation_subjects'
    end
  end
end