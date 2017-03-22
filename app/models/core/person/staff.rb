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


      belongs_to :sector_origin,   class_name: "Person::Sector"
      belongs_to :sector_current, class_name: "Person::Sector"
      belongs_to :branch_line, class_name: "Person::BranchLine"
      belongs_to :job
      belongs_to :civil_state, class_name: "Candidate::CivilState"
      belongs_to :contract_status
      belongs_to :city, class_name: "Address::City"
      belongs_to :education_background,  class_name: "Person::EducationBackground", foreign_key: :education_background_id

      validates :name, :code, :cpf, :job, :sector_current, :start_hour, :end_hour, presence: true

      validates_uniqueness_of :code


      validates :password, presence: true, length: {within: 8..28}
      validates :password_confirmation, presence: true, length: { within: 8..28}

      validate  :equal_passwords, on: :update

      validates :cpf, cpf: true, on: :create
      validates_date :born, :before => lambda {16.years.ago}



      validates :avatar, :personal_image, file_size: { less_than_or_equal_to: 10.megabytes.to_i }
      validates :avatar, :personal_image, file_content_type: { allow: ['image/jpeg', 'image/png'],
                                               message: 'Somente arquivos .jpg ou .png' }



      validates :curriculum, file_size: { less_than_or_equal_to: 60.megabytes.to_i,
                                       message: "Arquivo não pode exceder 60 MB" }
      validates :curriculum, file_content_type: { allow: ['application/pdf',   'application/docx',
                                                         'application/doc',   'application/xls',
                                                         'application/xlsx',  'application/ppt',
                                                         'application/pptx',  'application/zip'],
                                                message: 'Somente arquivos (.doc, .docx, .xls, .xlsx, .ppt. .pptx ou .zip)' }



      def permission_having? permission
        self.permissions.find_by(action_permission_id: permission.id) rescue false
      end

      def permission_group_having? group
        self.permission_groups.find_by(permission_group_id: group.id) rescue false
      end

      def supervisor?(station)
        self.attendants.where(privilege: 1, service_station_id: station.id).present? rescue false
      end

      def attendant?(station)
        self.attendants.where(privilege: 0, service_station_id: station.id).present? rescue false
      end

      def name_with_sector
        if self.sector_current.present?
          "#{name} - #{self.sector_current.acron}"
        else
          "#{name} - sem informação"
        end
      end

      def account
          self
      end

      def branch_line_numbers
        Person::BranchLine.where(id: self.branch_line_id).map(&:telephone)
      end

      private

      def equal_passwords
        if self.password != self.password_confirmation
          errors.add(:password, "Senhas não conferem")
        end
      end


    end
  end
end
