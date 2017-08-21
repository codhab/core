require_dependency 'core/application_record'

module Core
  module SocialWork
    class CandidateSchedule < ApplicationRecord
      self.table_name = 'generic.social_work_candidate_schedules'

      belongs_to :schedule_status
      has_many :schedule_interactions
      belongs_to :city,                   required: false,          class_name: ::Core::Address::City
      belongs_to :attendance_station      class_name: ::Core::SocialWork::AttendanceStation

      scope :by_name,  -> (name) {where('name ilike ?', "%#{name}%")}
      scope :by_cpf,  -> (cpf)   {where(cpf: cpf)}
      scope :by_date,  -> (date) {where(date: date)}

      validates :name, :city_id, :address, :hour, :date, :cpf, presence: true
      validates :cpf, cpf: true
    end
  end
end
