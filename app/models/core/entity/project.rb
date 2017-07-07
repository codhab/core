module Core
  module Entity
    class Project < ActiveRecord::Base
      self.table_name = 'extranet.entity_projects'

      enum situation: ['em_construção', 'em_produção', 'cancelado']
      enum units_type: ['uni_familiar', 'multi_familiar']

      validates :name, :description, :situation, :units, :units_type, presence: true
      validate  :units_not_equal_zero

      private

      def units_not_equal_zero
        if self.units.to_i == 0
          errors.add(:units, "Não pode ser igual a zero")
        end
      end 
    end
  end
end