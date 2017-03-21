module Project
  class Company < ActiveRecord::Base
    belongs_to :city,   class_name: "Address::City"

    has_many :enterprise, class_name: "Project::Enterprise"

    has_many :user_companies

    validates_presence_of :name, :trade,:cnpj #, :cep, :city, :address, :telephone

    validates :cnpj, cnpj: true

    audited

    def complete_name
      "#{self.id} - #{self.name}"
    end
  end
end
