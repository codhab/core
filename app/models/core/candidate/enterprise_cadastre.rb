require_dependency 'core/application_record'
require_dependency 'core/project/enterprise'
require_dependency 'core/indication/cadastre'
require_dependency 'core/indication/situation'

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

      scope :prepare_allotment, -> (allotment_id) {
        cadastres = CoreCandidate::Indication::Cadastre.where(allotment_id: allotment_id).map(&:id)
      }

      scope :prepare_step, -> (step_id) {
        allotments = CoreCandidate::Indication::Allotment.where(step_id: step_id).map(&:id)
        self.prepare_allotment(allotments)
      }


      scope :in_process, -> {
        self.where(inactive: nil).joins('INNER JOIN general_pontuations AS point
                    ON point.id = candidate_enterprise_cadastres.cadastre_id')
                  .where('point.situation_status_id = 4')
      }


    end
  end
end
