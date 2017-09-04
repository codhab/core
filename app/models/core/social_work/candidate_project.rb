require_dependency 'core/application_record'

module Core
  module SocialWork
    class CandidateProject < ApplicationRecord
      self.table_name = 'generic.social_work_candidate_projects'
        belongs_to :candidate
        belongs_to :project_situation
        belongs_to :city,              required: false, class_name: ::Core::Address::City

        has_many :project_interactions
        has_many :document_uploads
        has_many :allotment_projects
        has_many :step_projects

        def current_situation
          self.candidate_projects.first rescue nil
        end
    end
  end
end
