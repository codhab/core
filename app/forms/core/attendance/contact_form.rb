require_dependency 'core/candidate/cadastre'

module Core
  module Attendance
    class ContactForm < Core::Candidate::CadastreMirror
      validates :address, :cep, :city, presence: true
      validates :email, email: true, presence: true
      validates :telephone, presence: true

      def telephone=(value)
        self[:telephone] = only_numbers(value)
      end

      def celphone=(value)
        self[:celphone] = only_numbers(value)
      end

      def telephone_optional=(value)
        self[:telephone_optional] = only_numbers(value)
      end

      def cep=(value)
        self[:cep] = only_numbers(value)
      end

      private

      def only_numbers(value)
        value.gsub('-', '').gsub('(', '').gsub(')', '')
      end
    end
  end
end