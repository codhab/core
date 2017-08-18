require_dependency 'core/application_record'

module Core
  module SocialWork
    class ExecuteSituation < ApplicationRecord
      self.table_name = 'generic.social_work_execute_situations'

      belongs_to :execute
      belongs_to :user
    end
  end
end
