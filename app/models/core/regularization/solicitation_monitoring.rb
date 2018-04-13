require_dependency 'core/application_record'

module Core
  module Regularization
    class SolicitationMonitoring < ApplicationRecord
      self.table_name = 'extranet.regularization_solicitations'
      scope :by_cpf, -> (cpf) {where(cpf: cpf.gsub('-','').gsub('.',''))}
    end
  end
end