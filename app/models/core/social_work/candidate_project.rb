require_dependency 'core/application_record'

module Core
  module SocialWork
    class CandidateProject < ApplicationRecord
      self.table_name = 'generic.social_work_candidate_projects'
    end
  end
end
