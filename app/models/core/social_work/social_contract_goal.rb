require_dependency 'core/application_record'

module Core
  module SocialWork
    class SocialContractGoal < ApplicationRecord
      self.table_name = 'generic.social_contract_goals'

      belongs_to :category,  required: false, class_name: ::Core::SocialWork::SocialCategory
      belongs_to :contract, required: false, class_name: ::Core::SocialWork::SocialContract
      belongs_to :staff,                      class_name: ::Core::Person::Staff

      validates :metreage_goal, :category_id, presence: true

    end
  end
end
