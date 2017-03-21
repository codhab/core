
module CoreCandidate
  class EnterpriseCadastre < ApplicationRecord

    self.table_name = 'extranet.candidate_enterprise_cadastres'

    attr_accessor :cpf, :observation

    belongs_to :cadastre
    belongs_to :general_pontuation, class_name: "::CoreCandidate::View::GeneralPontuation", primary_key: :id, foreign_key: :cadastre_id
    belongs_to :enterprise, class_name: "CoreCandidate::Project::Enterprise"
    belongs_to :indication_cadastre, class_name: "CoreCandidate::Indication::Cadastre"

    belongs_to :indication_situation, class_name: "CoreCandidate::Indication::Situation"

    has_many :enterprise_cadastre_situations, class_name: "CoreCandidate::EnterpriseCadastreSituation"

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
