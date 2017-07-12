require_dependency 'core/entity/project_raffle'

module Core
  module Entity
    class ProjectRaffleForm < Core::Entity::ProjectRaffle

      validates :name, :quantity, :situation, presence: true
      validate  :not_equal_zero

      private
    
      def not_equal_zero
        if self.quantity.to_i <= 0
          errors.add(:quantity, "não pode ser igual a zero")
        end
      end      

    end
  end
end
