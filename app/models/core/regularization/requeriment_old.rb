require_dependency 'core/application_record'

module Core
  module Regularization
    class RequerimentOld < ApplicationRecord
      self.table_name = 'extranet.regularization_requeriment_olds'

      scope :name_candidate, -> (name_candidate) { where("name ILIKE '%#{name_candidate}%'")}
      scope :cpf, -> (cpf) {where(cpf: cpf.gsub('-','').gsub('.',''))}


    end
  end
end