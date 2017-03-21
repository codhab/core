module Person
  class Vocation < ActiveRecord::Base
    belongs_to :staff

    validates :start_date, :end_date, :period, presence: true

    validate :vocation_clt?, on: :create, if: "self.staff.contract_status_id == 2 && self.staff.job_id != 6"
    validate :vocation_servant?, on: :create, if: "self.staff.contract_status_id == 7 || self.staff.job_id == 6"
    validate :vocation_improver?, on: :create, if: "self.staff.contract_status_id == 4"

    scope :by_name,       -> (name) {joins(:staff).where('person_staffs.name ILIKE ?', "%#{name}%")}
    scope :by_code,       -> (code) {joins(:staff).where('person_staffs.code = ?', code)}
    scope :by_assigment,  -> (assigment) {where(assigment: assigment)}
    scope :by_month,      -> (month) {where("date_part('month', start_date) = ? ", month)}
    scope :by_year,       -> (year) {where("date_part('year', start_date) = ? ", year)}
    scope :by_sector,     -> (sector) {joins(staff: :sector_current).where("extranet.person_sectors.id = ?", sector)}

    private

    def vocation_clt?
      #refactor
      @staff = Person::Staff.find(self.staff_id)

      date = ((self.start_date - @staff.date_contract).to_i / 364.25).to_i

      if date < 1
        errors.add(:start_date, 'Funcionário não completou um ano de trabalho.')
        return false
      end

      date = @staff.date_contract - 1.day

      day = date.day
      month = date.month
      year  = self.assignment
      new_date = Date.parse("#{year}-#{month}-#{day}")

      if new_date > self.start_date
        errors.add(:start_date, 'Data não permitida para este exercício.')
        return false
      end


      vocations = @staff.vocations.where(assignment: self.assignment)
      period = (self.end_date - self.start_date).to_i + 1


      if vocations.present?
        if vocations.count == 2
          errors.add(:start_date, 'Funcionário já pussui dois periodos de férias marcado.')
          return false
        else
          first_vocation = vocations.first
          days_vocation = (first_vocation.end_date - first_vocation.start_date).to_i + 1
          case days_vocation
          when 10
            if period != 20
              errors.add(:start_date, 'Periodo de férias não pode ser diferente de 20 dias.')
              return false
            end
          when 15
            if period != 15
              errors.add(:start_date, 'Periodo de férias não pode ser diferente de 15 dias.')
              return false
            end
          when 20
            if period != 10
              errors.add(:start_date, 'Periodo de férias não pode ser diferente de 10 dias.')
              return false
            end
          else
            errors.add(:start_date, 'Funcionário já pussui 30 de férias marcados.')
            return false
          end
        end
      else
        unless period == 10 || period == 15 || period == 20 || period == 30
          errors.add(:start_date, 'Periodo de férias inválido.')
          return false
        end
      end
    end

    def vocation_servant?
      @staff = Person::Staff.find(self.staff_id)
      period = (self.end_date - self.start_date).to_i + 1
      vocations = @staff.vocations.where(assignment: self.assignment)

      if vocations.present?
        days = vocations.sum_days(self.assignment)
        if days == 30
          errors.add(:start_date, 'Periodo de férias completo.')
          return false
        else
          if (period + days) > 30
            errors.add(:start_date, "Periodo de férias inválido. Para este periodo você tem disponível #{30 - days} dias.")
            return false
          end
        end
      else
        if period < 10 || period > 30
          errors.add(:start_date, 'Periodo aquisitivo inválido')
          return false
        end
      end
    end

    def vocation_improver?
      @staff = Person::Staff.find(self.staff_id)
      period = (self.end_date - self.start_date).to_i + 1

      if period != 15
        errors.add(:start_date, 'Periodo aquisitivo inválido')
        return false
      end
    end



    def self.sum_days(assignment)
      days = 0
      where(assignment: assignment).each do |ass|
        days += (ass.end_date - ass.start_date).to_i + 1
      end

      return days
    end

  end
end
