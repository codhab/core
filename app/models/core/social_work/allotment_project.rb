require_dependency 'core/application_record'

module Core
  module SocialWork
    class AllotmentProject < ApplicationRecord
      self.table_name = 'generic.social_work_allotment_projects'

      attr_accessor :ids, :description

      belongs_to :candidate_project, required: false, class_name: ::Core::SocialWork::CandidateProject
      belongs_to :allotment
    end
  end
end
