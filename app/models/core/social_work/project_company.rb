require_dependency 'core/application_record'

module Core
  module SocialWork
    class ProjectCompany < ApplicationRecord
      self.table_name = 'generic.social_work_project_companies'
    end
  end
end
