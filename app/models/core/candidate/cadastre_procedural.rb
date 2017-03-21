module CoreCandidate
  class CadastreProcedural < ApplicationRecord

    self.table_name = 'extranet.candidate_cadastre_procedurals'

    belongs_to :procedural_status
    belongs_to :convocation
    belongs_to :cadastre
    belongs_to :assessment, class_name: "CoreCandidate::Protocol::Assessment"
    belongs_to :old_assessment, class_name: "CoreCandidate::Protocol::Assessment", foreign_key: 'old_process', primary_key: "document_number"
    validates :observation, :old_process, :procedural_status_id, presence: true

    before_validation :validate_process


    def current_status_procedural
        self.procedural_status.name rescue nil
    end


    def set_before_data!
      procedural = cadastre.current_procedural rescue nil

       if procedural.present?
        self.convocation_id = procedural.convocation_id
        self.old_process    = procedural.old_process
       self.assessment_id  = procedural.assessment_id
      end
    end

    private

    def validate_process
      assessment = CoreCandidate::Protocol::Assessment.find_by_document_number(self.old_process)

      if assessment.present?
        self.assessment_id = assessment.id
      else
        errors.add(:old_process, "Número de processo não encontrado.")
      end
    end

    def situation_uniq
      if cadastre.current_procedural_id == self.procedural_status_id
        errors.add(:procedural_status, "Candidato já se encontra neste situação. Favor selecionar outra.")
      end
    end


  end
end
