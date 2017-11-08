require_dependency 'core/application_record'

module Core
  module SocialWork
    class SocialControlProject < ApplicationRecord
      self.table_name = 'generic.social_work_social_control_projects'

      belongs_to :contract
      belongs_to :staff

      has_many :social_executions,      class_name: ::Core::SocialWork::SocialExecution,     foreign_key: :control_project_id, :dependent => :destroy
      has_many :social_project_goals,   class_name: ::Core::SocialWork::SocialProjectGoal,   foreign_key: :control_project_id, :dependent => :destroy
      has_many :social_category_totals, class_name: ::Core::SocialWork::SocialCategoryTotal, foreign_key: :control_project_id, :dependent => :destroy

      validates :description, presence: true
    end
  end
end
