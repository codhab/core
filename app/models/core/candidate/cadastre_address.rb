require_dependency 'core/address/unit'
require_dependency 'core/candidate/cadastre'

module Core
  module Candidate
    class CadastreAddress < ApplicationRecord
      self.table_name = 'extranet.candidate_cadastre_addresses'

      belongs_to :unit,                    required: false,   class_name: ::Core::Address::Unit
      belongs_to :cadastre,                required: false,   class_name: ::Core::Candidate::Cadastre
      belongs_to :cadastre_procedural,     required: false,   class_name: ::Core::Candidate::CadastreProcedural
      belongs_to :regularization_type,     required: false,   class_name: ::Core::Candidate::RegularizationType
      belongs_to :second_cadastre,         required: false,   class_name: ::Core::Candidate::Cadastre,                                foreign_key: :second_cadastre_id
      belongs_to :third_cadastre,          required: false,   class_name: ::Core::Candidate::Cadastre,              primary_key: :id, foreign_key: :third_cadastre_id
      belongs_to :fourth_cadastre,         required: false,   class_name: ::Core::Candidate::Cadastre,              primary_key: :id, foreign_key: :fourth_cadastre_id

      belongs_to :general_pontuation,      required: false,   class_name: ::Core::View::GeneralPontuation,          primary_key: :id, foreign_key: :cadastre_id

      enum situation_id:  ['reserva', 'distribuído', 'distrato','transferido', 'permuta','sobrestado']
      enum type_receipt:  ['segeth/codhab', 'transferencia']

    end
  end
end
