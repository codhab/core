require_dependency 'core/application_record'
require_dependency 'core/address/unit'

module Core
  module Regularization
    class Requeriment < ApplicationRecord
      self.table_name = 'extranet.regularization_requeriments'

      belongs_to :unit, required: false,  class_name: ::Core::Address::Unit

      enum marital_status: ['união_estável', 'solteiro']
      enum gender: [:masculino, :feminino]

      scope :name_candidate, -> (name_candidate) { where("name ILIKE '%#{name_candidate}%'")}
      scope :cpf, -> (cpf) {where(cpf: cpf)}

    end
  end
end
