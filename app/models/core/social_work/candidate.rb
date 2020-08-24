require_dependency 'core/application_record'

module Core
  module SocialWork
    class Candidate < ApplicationRecord
      self.table_name = 'generic.social_work_candidates'

      scope :by_name, ->(name) { where('name ilike ?', "%#{name}%")}
      scope :by_cpf,  ->(cpf)  { where(cpf: cpf) }


      belongs_to :city,        required: false, class_name: ::Core::Address::City
      belongs_to :burgh,       required: false, class_name: ::Core::Address::Burgh
      belongs_to :civil_state, required: false, class_name: ::Core::Candidate::CivilState
      belongs_to :benefit,     required: false, class_name: ::Core::SocialWork::Benefit
      belongs_to :pension,     required: false, class_name: ::Core::SocialWork::Pension
      belongs_to :education,   required: false, class_name: ::Core::SocialWork::Education

      enum gender: ['N/D', 'masculino', 'feminino']

      has_many :dependents
      has_many :candidate_schedules
      has_many :candidate_projects
      has_many :document_uploads
      has_many :project_interactions
      has_many :answers,           class_name: ::Core::SocialWork::Answer

      validates :cpf, cpf: true
      validates :name, :cpf, :civil_state, presence: true
      validate  :validate_schedule?, on: :create


      def current_project
        self.candidate_projects.first rescue nil
      end

      def validate_schedule?
        unless Core::SocialWork::CandidateSchedule.where(cpf: self.cpf).present?
          errors.add(:cpf, "CPF não possui agendamento.")
        end
      end
    end
  end
end
