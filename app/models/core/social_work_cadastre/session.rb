require_dependency 'core/application_record'

module Core
  module SocialWorkCadastre
    class Session
      include ActiveModel::Model

      attr_accessor :cnpj, :password, :id

      validates :cnpj, cnpj: true, presence: true
      validates :password, presence: true
      validate  :authenticate?

      private

      def authenticate?
        cadastre = Core::SocialWorkCadastre::Cadastre.where(cnpj: self.cnpj, assignment: 2019).order(created_at: :asc).last rescue nil

        if cadastre.nil? || cadastre.password != self.password
          errors.add(:email, "CNPJ ou senha inválidos")
        else
          self.id = cadastre.id
        end
      end

    end
  end
end
