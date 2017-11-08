require_dependency 'core/application_record'

module Core
  module SocialWork
    class SocialExecution < ApplicationRecord
      self.table_name = 'generic.social_work_social_executions'

      belongs_to :category, required: false, class_name: ::Core::SocialWork::SocialProjectCategory
      belongs_to :control_project, required: false, class_name: ::Core::SocialWork::SocialControlProject
      belongs_to :staff,    class_name: ::Core::Person::Staff

      has_many :social_category_totals, class_name: ::Core::SocialWork::SocialCategoryTotal, foreign_key: :execution_id, :dependent => :destroy

      validates :date,:social_value, :support_value,  presence: true
    end
  end
end
