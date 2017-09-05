require_dependency 'core/application_record'

module Core
  module SocialWork
    class AllotmentSituation < ApplicationRecord
      self.table_name = 'generic.social_work_allotment_situations'

      belongs_to :allotment_project
      belongs_to :user

      validates :observation, presence: true
    end
  end
end
