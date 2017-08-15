require_dependency 'core/entity/interest'

module Core
  module Entity
    class InterestForm < Core::Entity::Interest

      validate :unit_sale_validate

      private

      def unit_sale_validate
        if !self.unit_sale_ids.present?
          errors.add(:base, "Você precisa marcar ao menos 1 (um) endereço!")
        end

      end

    end
  end
end
