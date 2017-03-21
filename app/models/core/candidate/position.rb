module CoreCandidate
  class Position < ApplicationRecord

    self.table_name = 'extranet.candidate_positions'

    belongs_to :cadastre
    belongs_to :pontuation
    belongs_to :program

    scope :rii, -> { where(program_id: 1)}
    scope :rie, -> { where(program_id: 2)}
    scope :old, -> { where(program_id: 7)}
    scope :vulnerable, -> { where(program_id: 4)}
    scope :special, ->    { where(program_id: 5)}
  end
end
