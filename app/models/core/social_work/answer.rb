require_dependency 'core/application_record'

module Core
  module SocialWork
    class Answer < ApplicationRecord
      self.table_name = 'generic.social_work_answers'

      belongs_to :candidate
      belongs_to :question_multiple
    end
  end
end
