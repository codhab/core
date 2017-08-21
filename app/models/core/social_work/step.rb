require_dependency 'core/application_record'

module Core
  module SocialWork
    class Step < ApplicationRecord
      self.table_name = 'generic.social_work_steps'
      has_many :step_projects
    end
  end
end
