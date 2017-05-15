require_dependency 'core/application_record'
require_dependency 'core/person/staff'

module Core
  module Candidate
    class CadastreActivity < ApplicationRecord
      self.table_name = 'extranet.candidate_cadastre_activities'

      belongs_to :cadastre,         required: false
      belongs_to :staff,            required: false,     class_name: ::Core::Person::Staff
      belongs_to :activity_status,  required: false

      enum type_activity:   ['simples', 'judicial','crítico', 'corretiva', 'sistema']
    end
  end
end
