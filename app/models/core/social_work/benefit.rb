require_dependency 'core/application_record'

module Core
  module SocialWork
    class Benefit < ApplicationRecord
      self.table_name = 'generic.social_work_benefits'
    end
  end
end
