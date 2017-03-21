module Address
  class PrintType < ActiveRecord::Base

    has_many :print_allotments

    validates :name, :description, :main_signature, presence: true
    validates :main_cpf, :first_attestant_signature, presence: true
    validates :second_attestant_signature, presence: true
    validates :first_attestant_cpf, :second_attestant_cpf, presence: true
    
  end
end
