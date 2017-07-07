module Core
  module Entity
    class ProjectRaffle < ActiveRecord::Base
      self.table_name = 'extranet.entity_project_raffles'

      belongs_to :project, class_name: Core::Entity::Project
      has_many   :project_raffle_entities, class_name: Core::Entity::ProjectRaffleEntity, foreign_key: :raffle_id
      
      enum situation: ['aberto', 'sorteado', 'cancelado']
      
    end
  end
end