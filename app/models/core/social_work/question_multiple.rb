require_dependency 'core/application_record'

module Core
  module SocialWork
    class QuestionMultiple < ApplicationRecord
      self.table_name = 'generic.social_work_question_multiples'

      belongs_to :question, required: false, class_name: ::Core::SocialWork::Question
    end
  end
end
