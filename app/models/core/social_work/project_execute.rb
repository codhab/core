require_dependency 'core/application_record'

module Core
  module SocialWork
    class ProjectExecute < ApplicationRecord
      self.table_name = 'generic.social_work_project_executes'

      belongs_to :company
      belongs_to :allotment, required: false, class_name: ::Core::SocialWork::Allotment
      belongs_to :staff
    end
  end
end
