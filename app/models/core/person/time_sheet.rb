module Person
  class TimeSheet < ActiveRecord::Base
    attr_accessor :sector

    belongs_to :employee, class_name: "Person::Staff", foreign_key: 'employee_id'
    belongs_to :holiday
    belongs_to :staff
    belongs_to :vocation

    scope :by_status, -> (status = true) {joins(:employee).where('person_staffs.status = ?', status)}
    scope :by_sector, -> sector_current_id {joins(:employee).where('person_staffs.sector_origin_id = ?',sector_current_id)}
    scope :by_name,   -> (name) {joins(:employee).where('person_staffs.name ILIKE ?', "%#{name}%")}
    scope :by_code,   -> (code) {joins(:employee).where('person_staffs.code = ?', code)}
    scope :by_year,   -> (year) {where(year: year)}
    scope :by_month,   -> (month) {where(month: month)}

  end
end
