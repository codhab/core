module Person
  class Timetable < ActiveRecord::Base
    belongs_to :staff
    belongs_to :liberation_staff

    validates :timetable_date, uniqueness: { scope: [:period] }, presence: true


  end
end
