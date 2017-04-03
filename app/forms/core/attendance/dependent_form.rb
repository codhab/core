require_dependency 'core/candidate/cadastre'

module Core
  module Attendance
    class DependentForm < Core::Candidate::DependentMirror

      validates :name, :born, :income, presence: true
      validates :cpf, cpf: true, presence: true, if: :is_major?
      validates :special_condition_type, presence: true, if: 'self.special_condition_id == 2'
      validates :cid, presence: true, if: 'self.special_condition_id == 2'

      validate  :kinship_spouse

      private

      def is_major?
        (age >= 14)
      end

      def kinship_spouse
        if self.kinship_id == 6
          if self.cadastre_mirror.present? && 
             self.cadastre_mirror.dependent_mirrors.where(kinship_id: 6).where.not(id: self.id).present?
            errors.add(:kinship_id, "Já existe um conjugê cadastrado")
          end
        end

        old_dependent = self.cadastre_mirror.dependent_mirrors.find(self.id) rescue nil
        
        if old_dependent.present? && self.kinship_id != 6
          if old_dependent.kinship_id == 6
            errors.add(:kinship_id, "Não é possível remover o conjugê, para isso, abra um requerimento.")
          end
        end
      end

    end
  end
end