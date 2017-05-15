require_dependency 'core/application_record'
require_dependency 'core/indication/cadastre'
require_dependency 'core/indication/situation'
require_dependency 'core/project/enterprise'

module Core
  module Candidate
    class EnterpriseCadastre < ApplicationRecord
      self.table_name = 'extranet.candidate_enterprise_cadastres'

      attr_accessor :cpf, :observation

      belongs_to :cadastre,               required: false, class_name: ::Core::Candidate::Cadastre
      belongs_to :general_pontuation,     required: false, class_name: ::Core::View::GeneralPontuation, primary_key: :id, foreign_key: :cadastre_id
      belongs_to :enterprise,             required: false, class_name: ::Core::Project::Enterprise
      belongs_to :indication_cadastre,    required: false, class_name: ::Core::Indication::Cadastre
      belongs_to :indication_situation,   required: false, class_name: ::Core::Indication::Situation

      has_many :enterprise_cadastre_situations, class_name: ::Core::Candidate::EnterpriseCadastreSituation

      scope :by_indication_situation, -> (situation)  { where(indication_situation_id: situation )}
      scope :by_enterprise,           -> (enterprise) { where(enterprise_id: enterprise )}


    end
  end
end
