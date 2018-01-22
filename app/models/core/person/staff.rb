require_dependency 'core/application_record'

module Core
  module Person
    class Staff < ApplicationRecord
      self.table_name = 'extranet.person_staffs'

      belongs_to :sector_origin,         required: false,   class_name: ::Core::Person::Sector
      belongs_to :sector_current,        required: false,   class_name: ::Core::Person::Sector
      belongs_to :civil_state,           required: false,   class_name: ::Core::Candidate::CivilState
      belongs_to :city,                  required: false,   class_name: ::Core::Address::City
      belongs_to :job,                   required: false,   class_name: ::Core::Person::Job

      has_many :vocations
      has_many :allowances,   class_name: Core::Person::Allowance, foreign_key: 'employee_id'

      mount_uploader :avatar, Core::Cadastre::AvatarUploader

      has_many :notifications, class_name: ::Core::Person::Notification, foreign_key: :staff_id


      scope :actives, -> { where(status: true).order(:name) }

    end
  end
end
