module CoreCandidate
  class List < ApplicationRecord

    self.table_name = 'extranet.candidate_listss'

    extend FriendlyId
    friendly_id :title, use: :slugged

    scope :portal, ->   { where(list_type: 1, publish: true)}
    scope :extranet, -> { where(list_type: 0, publish: true)}

    scope :habitation,      -> { where(program_id: [1,2])}
    scope :regularization,  -> { where(program_id: [3])}

    enum list_type: ['extranet', 'portal']

    def program
      Candidate::Program.where(id: self.program_id)
    end

    def self.view_targets
      %w(Candidate::View::GeneralCandidate
         Candidate::View::GeneralPontuation
         Candidate::Cadastre
         Candidate::View::GeneralRegularization)
    end
  end
end
