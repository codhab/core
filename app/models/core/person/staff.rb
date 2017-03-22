require_dependency 'core/application_record'

module Core
  module Person
    class Staff < ActiveRecord::Base

      attr_accessor :password_confirmation

      default_scope { order('name ASC') }

      scope :by_status, -> (status = true) {where(status: status)}
      scope :by_sector, -> sector_current_id {where(sector_current_id: sector_current_id)}
      scope :by_name,   -> (name) {where('name ILIKE ?', "%#{name}%")}
      scope :by_code,   -> (code) {where(code: code)}

      scope :actives,   ->  {where(status: true)}


      scope :birthdays_week, -> { unscoped.where("status = true and to_char(born::date, 'mm-dd') between ? and ?",
                                                 Date.today.beginning_of_week.strftime("%m-%d"),
                                                 Date.today.end_of_week.strftime("%m-%d"))
                                          .order("date_part('day', born)")
                                }


      has_many :attendants, class_name: "Attendance::Attendant"
      has_many :service_stations, class_name: "Attendance::ServiceStation", through: :attendants

      has_one :helpdesk_attendant, class_name: "Helpdesk::TicketAttendant"

      has_many :permissions, class_name: "Main::UserPermission"
      has_many :permission_groups, class_name: "Main::UserPermissionGroup"


      has_many :responsible, class_name: "Person:Sector"
      has_many :conducts, class_name: "Protocol::Conduct"
      has_many :responsibles, class_name: "Helpdesk::TicketOcurrence"

      has_many :time_sheets
      has_many :time_tables
      has_many :vocations
      has_many :timetables
      has_many :staff_mirrors
      has_many :allowances,   class_name: "Person::Allowance", foreign_key: 'employee_id'


      belongs_to :sector_origin,         required: false,   class_name: ::Core::Person::Sector
      belongs_to :sector_current,        required: false,   class_name: ::Core::Person::Sector
      belongs_to :civil_state,           required: false,   class_name: ::Core::Candidate::CivilState
      belongs_to :city,                  required: false,   class_name: ::Core::Address::City




    end
  end
end
