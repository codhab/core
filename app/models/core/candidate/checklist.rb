module CoreCandidate
  class Checklist < ApplicationRecord

    self.table_name = 'extranet.candidate_checklists'

    belongs_to :checklist_type

    scope :by_type, -> (type) { where(checklist_type_id: type)}

  end
end
