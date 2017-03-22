module Core
  module Entity
    class Member < ApplicationRecord
      self.table_name = "extranet.entity_members"
      
      belongs_to :member_job
      belongs_to :cadastre
      belongs_to :city, -> {federal_district}, class_name: "Address::City"

      scope :without_president, -> { where.not(member_job_id: 2) }
      scope :only_president,    -> { where(member_job_id: 2)}

      has_many  :member_additionals
    end
  end
end
