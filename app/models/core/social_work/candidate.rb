require_dependency 'core/application_record'

module Core
  module SocialWork
    class Candidate < ApplicationRecord
      self.table_name = 'generic.social_work_candidates'

      belongs_to :city,        required: false, class_name: ::Core::Address::City
      belongs_to :civil_state, required: false, class_name: ::Core::Candidate::CivilState
      belongs_to :benefit,     required: false, class_name: ::Core::SocialWork::Benefit
      belongs_to :pension,     required: false, class_name: ::Core::SocialWork::Pension
      belongs_to :education,   required: false, class_name: ::Core::SocialWork::Education

      enum gender: ['N/D', 'masculino', 'feminino']

      has_many :dependents
      has_many :candidate_schedules
      has_many :candidate_projects
      has_many :document_uploads
      has_many :answers,           class_name: ::Core::SocialWork::Answer

      validates :cpf, cpf: true


      def current_project
        self.candidate_projects.first rescue nil
      end

    end
  end
end
