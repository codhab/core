module Core
  module Candidate
    class Cadin < ApplicationRecord
      self.table_name = 'extranet.candidate_cadins'

      belongs_to :occurrence_cadin,  required: false, class_name: ::Core::Candidate::OccurrenceCadin
      belongs_to :signed_instrument, required: false, class_name: ::Core::Candidate::SignedInstrument
      belongs_to :city,              required: false, class_name: ::Core::Address::City

      scope :name_candidate,   -> (name_candidate) { where(name: name_candidate) }
      scope :cpf,          -> (cpf) { where(cpf: cpf) }

    end
  end
end
