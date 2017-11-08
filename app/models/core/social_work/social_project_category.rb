require_dependency 'core/application_record'

module Core
  module SocialWork
    class SocialProjectCategory < ApplicationRecord
      self.table_name = 'generic.social_work_social_project_categories'

      has_many :social_executions,      class_name: ::Core::SocialWork::SocialExecution,     foreign_key: :category_id, :dependent => :destroy
      has_many :social_project_goals,   class_name: ::Core::SocialWork::SocialProjectGoal,   foreign_key: :category_id, :dependent => :destroy
      has_many :social_category_totals, class_name: ::Core::SocialWork::SocialCategoryTotal, foreign_key: :category_id, :dependent => :destroy

      scope :by_name,  -> (name)  {where('name ilike ?', "%#{name}%")}

      validates :name, presence: true

    end
  end
end
