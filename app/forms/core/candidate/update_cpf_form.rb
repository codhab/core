require_dependency 'core/candidate/dependent'

module Core
  module Candidate
    class UpdateCpfForm < Core::Candidate::Cadastre #:nodoc:

      attr_accessor :observation, :cpf_secundary

      validates :observation, presence: true
    end
  end
end
