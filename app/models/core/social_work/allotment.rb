require_dependency 'core/application_record'

module Core
  module SocialWork
    class Allotment < ApplicationRecord
      self.table_name = 'generic.social_work_allotments'

      has_many :allotment_projects, class_name: ::Core::SocialWork::AllotmentProject
      has_many :project_executes,   class_name: ::Core::SocialWork::ProjectExecute

    end
  end
end
