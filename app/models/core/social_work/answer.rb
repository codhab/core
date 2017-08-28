require_dependency 'core/application_record'

module Core
  module SocialWork
    class Answer < ApplicationRecord
      self.table_name = 'generic.social_work_answers'

      attr_accessor :type

      belongs_to :candidate
      belongs_to :question_multiple

      scope :by_type,  -> (type) {joins(question_multiple: :question).where('social_work_questions.question_type = ?', type)}
    end
  end
end
