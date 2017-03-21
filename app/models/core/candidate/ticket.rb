module CoreCandidate
  class Ticket < ApplicationRecord

    self.table_name = 'extranet.candidate_tickets'

    belongs_to :cadastre
    belongs_to :staff, class_name: "CoreCandidate::Person::Staff"
    belongs_to :subject

    enum status: ['Aberto', 'Em atendimento', 'Fechado']
    scope :open,        -> { where(status: 0).order('created_at desc') }
    scope :in_progress, -> { where(status: 1).order('created_at desc') }
    scope :closed,      -> { where(status: 2).order('created_at desc') }

  end
end
