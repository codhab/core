require_dependency 'core/application_record'
require_dependency 'core/person/staff'

module Core
  module Candidate
    class CadastreActivity < ApplicationRecord
      self.table_name = 'extranet.candidate_cadastre_activities'

      belongs_to :cadastre,         required: false, class_name: ::Core::Candidate::Cadastre
      belongs_to :staff,            required: false, class_name: ::Core::Person::Staff
      belongs_to :activity_status,  required: false, class_name: ::Core::Candidate::ActivityStatus

      enum type_activity:   ['simples', 'judicial','crítico', 'corretiva', 'sistema']

      validates :activity_status, :type_activity, :observation, presence: true
      validates :cadastre, :staff, presence: true
    end
  end
end
