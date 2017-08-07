require_dependency 'core/application_record'

module Core
  module SocialWork
    class Candidate < ApplicationRecord
      self.table_name = 'generic.social_work_candidates'
    end
  end
end
