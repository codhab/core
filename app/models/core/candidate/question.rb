module CoreCandidate
  class Question <  ApplicationRecord

    self.table_name = 'extranet.candidate_questions'

    belongs_to :ticket
    belongs_to :subject
    belongs_to :staff, class_name: "CoreCandidate::Person::Staff"

  end
end
