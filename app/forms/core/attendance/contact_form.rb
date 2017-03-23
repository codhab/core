require_dependency 'core/candidate/cadastre'

module Core
  module Attendance
    class ContactForm < Core::Candidate::CadastreMirror
      validates :telephone, presence: true
    end
  end
end