require_dependency 'core/application_record'

module Core
  module SocialWork
    class CandidateSchedule < ApplicationRecord
      self.table_name = 'generic.social_work_candidate_schedules'

      belongs_to :schedule_status
      belongs_to :city,               required: false, class_name: ::Core::Address::City
      belongs_to :burgh,              required: false, class_name: ::Core::Address::Burgh
      belongs_to :company,            required: false, class_name: ::Core::SocialWork::Company
      belongs_to :attendance_station, required: false, class_name: ::Core::TechnicalAssistance::Station, foreign_key: :attendance_station_id
      belongs_to :candidate,          required: false, class_name: ::Core::SocialWork::Candidate, foreign_key: :cpf, primary_key: :cpf

      has_many :schedule_interactions

      enum priority: ['Baixa','Média','Alta']

      scope :by_name,       ->(name)    { where('name ilike ?', "%#{name}%") }
      scope :by_cpf,        ->(cpf)     { where(cpf: cpf.gsub('.','').gsub('-','')) }
      scope :by_date,       ->(date)    { where(date: date) }
      scope :by_station,    ->(station) { where(attendance_station_id: station) }
      scope :by_city,       ->(city)    { where(city_id: city) }
      scope :by_start_date, ->(date) {where('social_work_candidate_schedules.created_at::date >= ?', Date.parse(date))}
      scope :by_end_date,   ->(date) {where('social_work_candidate_schedules.created_at::date <= ?', Date.parse(date))}
      scope :by_profile,    ->(profile) {

        if profile == "true"
          joins(:candidate)
        else
          joins('left join generic.social_work_candidates cand on cand.cpf = generic.social_work_candidate_schedules.cpf').where('cand.id is null')
        end
      }

      validates :hour, :date, :city_id, presence: true
      validates :cpf, cpf: true, if: 'cpf.present?'

      after_create :set_order
      after_destroy :set_order

      def set_order
        Core::SocialWork::CandidateSchedule.where(city_id: self.city_id).order(created_at: :asc).each_with_index do |schedule, i|
          schedule.order = i + 1
          schedule.save(validate: false)
        end
      end
    end
  end
end
