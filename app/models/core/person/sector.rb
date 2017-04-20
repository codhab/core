require_dependency 'core/application_record'

module Core
  module Person
    class Sector < ApplicationRecord
      self.table_name = 'extranet.person_sectors'

      default_scope { order(:name) }

      scope :by_status, -> (status = true) { where(:status => status) }
      scope :by_name, -> (name) { where('name ilike ?', "%#{name}%") }

      scope :active, -> {where(status: true)}

      has_many :subordinates, class_name: "Sector", foreign_key: "father_id"
      has_many :staffs, foreign_key: "sector_current_id"

      belongs_to :father,      required: false, class_name: ::Core::Person::Sector, foreign_key: 'father_id'
      belongs_to :responsible, required: false, class_name: ::Core::Person::Staff,  foreign_key: 'responsible_id'

      has_many :childrens,   class_name: ::Core::Person::Sector, foreign_key: 'id', primary_key: 'father_id'
      has_many :branch_line

      has_many :tickets,     class_name: "Helpdesk::Ticket"

      has_many :assessments, class_name: "Protocol::Assessment"

      has_many :conducts,    class_name: "Protocol::Conduct"

    end
  end
end
