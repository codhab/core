require_dependency 'core/application_record'

module Core
  module SocialWork
    class SocialCandidate < ApplicationRecord # :nodoc:
      self.table_name = 'generic.social_candidates'

      attr_accessor :situation_id

      belongs_to :company, class_name: 'Core::SocialWork::Company'
      belongs_to :station, class_name: 'Core::TechnicalAssistance::Station'
      belongs_to :project, class_name: 'Core::SocialWork::SocialProject', foreign_key: :project_id

      has_many :candidate_situations, class_name: 'Core::SocialWork::SocialCandidateSituation', foreign_key: :candidate_id

      scope :situations, ->(situation) do
        @situation = Core::SocialWork::SocialCandidateSituation.select(:candidate_id)
                                                               .where(id: Core::SocialWork::SocialCandidateSituation
                                                               .select('max(id)').group(:candidate_id), situation_id: situation)
        where(id: @situation)
      end

      scope :last_situation, -> do
        @situation = Core::SocialWork::SocialCandidateSituation.select(:candidate_id)
                                                               .joins('inner join generic.social_situation_types on social_situation_types.id = social_candidate_situations.situation_id')
                                                               .where(id: Core::SocialWork::SocialCandidateSituation
                                                               .select('max(id)').group(:candidate_id))
                                                               .where("social_situation_types.countable is true")
        where(id:  @situation)
      end

      validates :name, presence: true
      validates :cpf, cpf: true, if: 'self.cpf.present?'


      scope :by_name, ->(name) { where('name ilike ?', "%#{name}%") }
      scope :by_process, ->(process) { where(process_number: process) }
      scope :by_company, ->(company) { where(company_id: company) }
      scope :by_station, ->(station) { where(station_id: station) }
      scope :by_contract_number, ->(contract) { where(contract_number: contract) }

      def create_situation(candidate, situation, staff)
        @situation = Core::SocialWork::SocialCandidateSituation.new(
          candidate_id: candidate,
          situation_id: situation,
          staff_id: staff
        )
        @situation.save
      end
    end
  end
end
