require_dependency 'core/application_record'

module Core
  module SocialWork
    class Dependent < ApplicationRecord
      self.table_name = 'generic.social_work_dependents'
      belongs_to :candidate
      belongs_to :civil_state, required: false, class_name: ::Core::Candidate::CivilState
      belongs_to :education,   required: false, class_name: ::Core::SocialWork::Education
      belongs_to :kinship,     required: false, class_name: ::Core::Candidate::Kinship

      enum gender: ['N/D', 'masculino', 'feminino']

    end
  end
end
