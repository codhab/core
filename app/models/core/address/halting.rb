module Address
  class Halting
    include ActiveModel::Model

    attr_accessor :cpf, :observation, :cadastre

    validates :cpf, cpf: true, presence: true
    validates :observation, presence: true

    validate  :cpf_valid?

    private

    def cpf_valid?
      @cadastre = ::Candidate::Cadastre.find_by_cpf(self.cpf) rescue nil

      if @cadastre.nil?
        errors.add(:cpf, 'CPF não existe na base de dados')
        return false
      end


    end

  end
end
