module Core
  module Candidate
    class Search # :nodoc:
      include ActiveModel::Model
      attr_accessor :cpf, :cadastre_id, :program
      validates :cpf, cpf: true, presence: true
      validate  :cpf_exists?

      private

      def cpf_exists?
        cadastre = Core::Candidate::Cadastre.find_by_cpf(cpf) rescue nil
        if cadastre.nil?
          errors.add(:cpf, 'CPF não encontrado.')
        else
          self.cadastre_id = cadastre
        end
      end
    end
  end
end
