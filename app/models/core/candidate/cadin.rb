module CoreCandidate
  class Cadin < ApplicationRecord

    self.table_name = 'extranet.candidate_cadins'

    belongs_to :occurrence_cadin
    belongs_to :signed_instrument
    belongs_to :city, class_name: "CoreAddress::City"

    scope :name_candidate,   -> (name_candidate) { where(name: name_candidate) }
    scope :cpf,          -> (cpf) { where(cpf: cpf) }

  end
end
