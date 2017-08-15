require_dependency 'core/application_record'

module Core
  module SocialWork
    class Question < ApplicationRecord
      self.table_name = 'generic.social_work_questions'

      has_many :question_multiples
    end
  end
end
