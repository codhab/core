module Person
  class StaffMirror < ActiveRecord::Base
    belongs_to :civil_state, class_name: "Candidate::CivilState"
    belongs_to :contract_status
    belongs_to :city, class_name: "Address::City"
    belongs_to :staff
    belongs_to :education_background,  class_name: "Person::EducationBackground", foreign_key: :education_background_id

    validates :spouse_name, presence: true, if: :married?
    validates :education_background, presence: true
    validates :graduation, presence: true, if: :education_background? 

    private

    def married?
      [2,7].include? self.civil_state_id
    end

    def education_background?
      self.education_background_id == 2
    end

  end
end
