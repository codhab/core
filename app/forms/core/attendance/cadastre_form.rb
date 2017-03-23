require_dependency 'core/candidate/cadastre'

module Core
  module Attendance
    class CadastreForm < Core::Candidate::CadastreMirror
      validates :name, presence: true
    end
  end
end