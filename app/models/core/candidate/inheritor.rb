require_dependency 'core/application_record'

module Core
  module Candidate
    class Inheritor < ApplicationRecord
      self.table_name = 'extranet.candidate_inheritors'

      belongs_to :cadastre,        required: false,  class_name: ::Core::Candidate::Cadastre
      belongs_to :inheritor_type,  required: false,  class_name: ::Core::Candidate::InheritorType
      belongs_to :civil_state ,    required: false,  class_name: ::Core::Candidate::CivilState

      scope :name_inheritor,  -> (name_inheritor) {where(name: name_inheritor)}
      scope :cpf,  -> (cpf) {where(cpf: cpf)}
      scope :type_inheritor,  -> (type_inheritor) {where(type_inheritor_id: type_inheritor)}

      enum gender: ['N/D', 'masculino', 'feminino']

      validates :cpf, cpf: true

      validates :name, :cpf, :born, :observation, presence: true

      def self.log_inheritor!(cadastre, user, status, observation)
        @cadastre = Candidate::CadastreActivity.new(
          cadastre_id: cadastre,
          staff_id: user,
          activity_status_id: status,
          type_activity: 2,
          observation: observation
        )
        @cadastre.save
      end
    end
  end
end
