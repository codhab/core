module CoreCandidate
  class ChecklistType < ApplicationRecord

    self.table_name = 'extranet.candidate_checklist_types'

    belongs_to :program

    has_many :checklists

    scope :by_program, -> (program) { where(program_id: program)}

  end
end
