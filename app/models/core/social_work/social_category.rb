require_dependency 'core/application_record'

module Core
  module SocialWork
    class SocialCategory < ApplicationRecord
      self.table_name = 'generic.social_categories'

      has_many :executions,             class_name: ::Core::SocialWork::SocialExecution,     foreign_key: :category_id
      has_many :goals,                  class_name: ::Core::SocialWork::SocialContractGoal,   foreign_key: :category_id
      has_many :social_category_totals, class_name: ::Core::SocialWork::SocialCategoryTotal, foreign_key: :category_id

      scope :by_name,  -> (name)  {where('name ilike ?', "%#{name}%")}

      validates :name, presence: true

    end
  end
end
