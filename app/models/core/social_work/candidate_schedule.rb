require_dependency 'core/application_record'

module Core
  module SocialWork
    class CandidateSchedule < ApplicationRecord
      self.table_name = 'generic.social_work_candidate_schedules'

      belongs_to :schedule_status
      belongs_to :city,               required: false, class_name: ::Core::Address::City
      belongs_to :company,            required: false, class_name: ::Core::SocialWork::Company
      belongs_to :attendance_station, required: false, class_name: ::Core::TechnicalAssistance::Station, foreign_key: :attendance_station_id

      has_many :schedule_interactions

      enum priority: ['Baixa','Média','Alta']

      scope :by_name,    -> (name)    {where('name ilike ?', "%#{name}%")}
      scope :by_cpf,     -> (cpf)     {where(cpf: cpf.gsub('.','').gsub('-',''))}
      scope :by_date,    -> (date)    {where(date: date)}
      scope :by_station, -> (station) {where(attendance_stations_id: station)}

      validates :name, :city_id, :address, :hour, :date, :cpf, presence: true
      validates :cpf, cpf: true

    end
  end
end
