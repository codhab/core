require_dependency 'core/application_record'

module Core
  module SocialWork
    class Education < ApplicationRecord
      self.table_name = 'generic.social_work_educations'
    end
  end
end
