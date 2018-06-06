module Core
  module TechnicalAssistance
    class Member < ApplicationRecord
      self.table_name = 'extranet.technical_assistance_members'
      belongs_to :station, required: false, class_name: ::Core::TechnicalAssistance::Station
      belongs_to :staff, class_name: Core::Person::Staff
      belongs_to :type_member, class_name: Core::TechnicalAssistance::TypeMember
      belongs_to :category, class_name: Core::TechnicalAssistance::Category

      validates_presence_of :staff_id, :category_id, :type_member_id
      validates_uniqueness_of :staff_id
    end
  end
end
