module Project
  class Typology < ActiveRecord::Base
    has_many :enterprise
    has_many :enterprise_typologies

    validates :name, :home_type, :private_area, :income_family, :initial_value, :end_value, presence: true

    def complete_name
      "#{self.id} - #{self.name}"
    end

    def name_of_method
      "#{self.name} - #{self.home_type} - #{self.private_area} m²"
    end

  end
end
