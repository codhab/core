module CoreCandidate
  class CadastreChecklist < ApplicationRecord
    self.table_name = 'extranet.candidate_cadastre_checklists'

    belongs_to :cadastre_mirror
    belongs_to :checklist  
  end
end
