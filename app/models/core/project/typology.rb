require_dependency 'core/application_record'

module Core
  module Project
    class Typology < ApplicationRecord
      self.table_name = 'extranet.project_typologies'

      has_many :enterprise
      has_many :enterprise_typologies

      def complete_name
        "#{self.id} - #{self.name}"
      end

      def name_of_method
        "#{self.name} - #{self.home_type} - #{self.private_area} m²"
      end

    end
  end
end
