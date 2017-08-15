require_dependency 'core/application_record'

module Core
  module Entity
    class Interest < ApplicationRecord
      self.table_name = 'extranet.entity_interests'

      belongs_to :unit_sale, class_name: ::Core::Entity::UnitSale
      belongs_to :entity,    class_name: ::Core::Entity::Cadastre, foreign_key: :entity_id


      def unit_sales
        Core::Entity::UnitSale.where(id: self.unit_sale_ids)
      end

      def protocol
        "#{self.id}#{self.created_at.strftime("%Y")}"
      end


    end
  end
end
