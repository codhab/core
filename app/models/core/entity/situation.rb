require_dependency 'core/application_record'

module Core
  module Entity
    class Situation < ApplicationRecord
      self.table_name = "extranet.entity_situations"

      belongs_to :staff,             class_name: ::Core::Person::Staff
      belongs_to :cadastre,          class_name: ::Core::Entity::Cadastre
      belongs_to :situation_status,  class_name: ::Core::Entity::SituationStatus

    end
  end
end
