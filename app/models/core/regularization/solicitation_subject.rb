require_dependency 'core/application_record'

module Core
  module Regularization
    class SolicitationSubject < ApplicationRecord
      self.table_name = 'extranet.regularization_solicitation_subjects'
      has_many :solicitations
    end
  end
end