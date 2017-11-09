require_dependency 'core/application_record'

module Core
  module SocialWork
    class SocialCategory < ApplicationRecord
      self.table_name = 'generic.social_categories'

      has_many :social_executions,      class_name: ::Core::SocialWork::SocialExecution,     foreign_key: :category_id, :dependent => :destroy
      has_many :social_execution_goals,   class_name: ::Core::SocialWork::SocialExecutionGoal,   foreign_key: :category_id, :dependent => :destroy
      has_many :social_category_totals, class_name: ::Core::SocialWork::SocialCategoryTotal, foreign_key: :category_id, :dependent => :destroy

      scope :by_name,  -> (name)  {where('name ilike ?', "%#{name}%")}

      validates :name, presence: true

    end
  end
end
