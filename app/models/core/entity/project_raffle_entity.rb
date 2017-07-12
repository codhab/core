require_dependency 'core/application_record'

module Core
  module Entity
    class ProjectRaffleEntity < ApplicationRecord
      self.table_name = 'extranet.entity_project_raffle_entities'

      belongs_to :entity, class_name: Core::Entity::Cadastre

      validates :entity_id, uniqueness: true, presence: true
    end
  end
end