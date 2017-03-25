require_dependency 'core/candidate/cadastre'

module Core
  module Attendance
    class DependentForm < Core::Candidate::DependentMirror

      validates :name, :born, :income, presence: true
    end
  end
end