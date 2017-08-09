require_dependency 'core/application_record'

module Core
  module SocialWork
    class Candidate < ApplicationRecord
      self.table_name = 'generic.social_work_candidates'

      has_many :dependents
      has_many :candidate_schedules
      has_many :candidate_projects
      belongs_to :city,                   required: false,          class_name: ::Core::Address::City
      belongs_to :civil_state,              required: false,          class_name: ::Core::Candidate::CivilState
    end
  end
end
