require_dependency 'core/application_record'

module Core
  module SocialWork
    class SocialCategoryTotal < ApplicationRecord # :nodoc:
      self.table_name = 'generic.social_category_totals'

      belongs_to :category, required: false,  class_name: ::Core::SocialWork::SocialCategory
      belongs_to :staff,    required: false,  class_name: ::Core::Person::Staff
      belongs_to :execution, required: false, class_name: ::Core::SocialWork::SocialExecution

      validates :category_id, :value, :metreage, presence: true

    end
  end
end
