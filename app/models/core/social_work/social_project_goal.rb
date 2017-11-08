require_dependency 'core/application_record'

module Core
  module SocialWork
    class SocialProjectGoal < ApplicationRecord
      self.table_name = 'generic.social_work_social_project_goals'

      belongs_to :category, required: false, class_name: ::Core::SocialWork::SocialProjectCategory
      belongs_to :control_project, required: false, class_name: ::Core::SocialWork::SocialControlProject
      belongs_to :staff,    class_name: ::Core::Person::Staff

      validates :metreage_goal,:category_id, presence: true

    end
  end
end
