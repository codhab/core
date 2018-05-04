require_dependency 'core/application_record'

module Core
  module Candidate
    class CadastreProcedural < ApplicationRecord
      self.table_name = 'extranet.candidate_cadastre_procedurals'

      belongs_to :procedural_status,  required: false, class_name: ::Core::Candidate::ProceduralStatus
      belongs_to :convocation,        required: false, class_name: ::Core::Candidate::Convocation
      belongs_to :cadastre,           required: false, class_name: ::Core::Candidate::Cadastre
      belongs_to :assessment,         required: false, class_name: ::Core::Protocol::Assessment
      belongs_to :staff,                 required: false, class_name: ::Core::Person::Staff, foreign_key: 'staff_id'
      

    end
  end
end
