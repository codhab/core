require_dependency 'core/candidate/cadastre'

module Core
  module Attendance
    class DependentForm < Core::Candidate::DependentMirror

      validates :name, :born, :income, presence: true
      validates :cpf, cpf: true, presence: true, if: :is_major?

      private

      def is_major?
        age >= 14
      end
    end
  end
end