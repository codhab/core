module Person
  class BranchLine < ActiveRecord::Base
    validates_presence_of :telephone


    audited


    scope :by_sector,   -> (sector) {where(sector_id: sector)}

    scope :by_name, -> (name) {
      user = Person::Staff.where("branch_line_id <> '{}' and name ilike ?", "%#{name}%")
      where(id: user.map(&:branch_line_id))
    }

    def staffs
      Person::Staff.where("'#{self.id}' = ANY(branch_line_id)")
    end



  end
end
