require_dependency 'core/application_record'

module Core
  module Candidate
    class Question <  ApplicationRecord
      self.table_name = 'extranet.candidate_questions'

      belongs_to :staff,    required: false, class_name: ::Core::Person::Staff

    end
  end
end
