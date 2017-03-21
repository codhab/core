module Person
  class Allowance < ActiveRecord::Base
    belongs_to :employee, class_name: "Person::Staff" , foreign_key: 'employee_id'
    belongs_to :staff

    validates :allowance_date, presence: true

    validate :vocation_clt?, on: :create

    private

    def vocation_clt?
      @staff = Person::Staff.find(self.employee_id)
      date = ((self.allowance_date - @staff.date_contract).to_i / 364.25).to_i

      if date < 1
        errors.add(:allowance_date, 'Abono não pode ser marcado neste periodo.')
        return false
      end

      allowances = @staff.allowances.where("date_part('year', allowance_date) = ? and status is true", self.allowance_date.year).count

      if allowances >= 5
        errors.add(:allowance_date, 'Todos os abonos marcados para este periodo.')
        return false
      end
    end

  end
end
